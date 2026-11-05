import 'dart:io';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:elkawther/core/services/local_notifications.dart'
    show flutterLocalNotificationsPlugin;

final _secureStorage = SecureStorageHelper();

Future<tz.Location> getEgyptTimeZoneLocation() async {
  tz.initializeTimeZones();
  return tz.getLocation('Africa/Cairo');
}

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  } else if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}

Future<bool> isExactAlarmAllowed() async {
  if (!Platform.isAndroid) return false;
  final androidPlugin =
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
  return await androidPlugin?.canScheduleExactNotifications() ?? false;
}

Future<void> requestExactAlarmPermissionIfNeeded() async {
  if (Platform.isAndroid) {
    final androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.requestExactAlarmsPermission();
  }
}

Future<void> createNotificationChannel({
  required String channelId,
  required String channelName,
  required String channelDescription,
}) async {
  if (Platform.isAndroid) {
    final androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (androidPlugin != null) {
      final androidChannel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
      );
      await androidPlugin.createNotificationChannel(androidChannel);
    }
  }
}

Future<void> requestPermissionsOnStart() async {
  if (await Permission.notification.isDenied ||
      await Permission.notification.isPermanentlyDenied) {
    await Permission.notification.request();
  }

  final isExactAlarmGranted = await isExactAlarmAllowed();
  if (!isExactAlarmGranted) {
    await requestExactAlarmPermissionIfNeeded();
  }
}

Future<void> scheduleNotificationBasedOnLocation({
  required int id,
  required String title,
  required String body,
  required DateTime dateTime,
  required String channelId,
  required String channelName,
  required String channelDescription,
}) async {
  final location = await getEgyptTimeZoneLocation();

  final now = tz.TZDateTime.now(location);
  final scheduledDate = tz.TZDateTime(
    location,
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
    dateTime.second,
  );

  await createNotificationChannel(
    channelId: channelId,
    channelName: channelName,
    channelDescription: channelDescription,
  );

  if (scheduledDate.isBefore(now)) {
    return;
  }

  await flutterLocalNotificationsPlugin.cancel(id);
  final scheduleMode =
      await isExactAlarmAllowed()
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;
  final details = NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
    ),
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: null,
    );
  } on PlatformException catch (error) {
    if (error.code != 'exact_alarms_not_permitted' ||
        scheduleMode != AndroidScheduleMode.exactAllowWhileIdle) {
      rethrow;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }
}

Future<void> saveNotificationId(String medicineName, int id) async {
  final prefs = await SharedPreferences.getInstance();

  final userToken = await _secureStorage.safeRead('token');
  if (userToken == null) {
    return;
  }

  final key = 'notif_ids_${userToken}_$medicineName';
  final existingIds = prefs.getStringList(key) ?? [];

  if (!existingIds.contains(id.toString())) {
    existingIds.add(id.toString());
    await prefs.setStringList(key, existingIds);
  }
}

Future<List<int>> getNotificationIds(String medicineName) async {
  final prefs = await SharedPreferences.getInstance();
  final userToken = await _secureStorage.safeRead('token');
  if (userToken == null) {
    return [];
  }

  final key = 'notif_ids_${userToken}_$medicineName';
  final ids = prefs.getStringList(key) ?? [];
  return ids.map((e) => int.tryParse(e) ?? 0).toList();
}

Future<void> removeNotificationId(String medicineName, int id) async {
  final prefs = await SharedPreferences.getInstance();
  final userToken = await _secureStorage.safeRead('token');
  if (userToken == null) {
    return;
  }

  final key = 'notif_ids_${userToken}_$medicineName';
  final existingIds = prefs.getStringList(key) ?? [];
  existingIds.remove(id.toString());
  await prefs.setStringList(key, existingIds);
}

Future<void> cancelNotificationsForMedicine(String medicineName) async {
  final ids = await getNotificationIds(medicineName);
  for (final id in ids) {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  final prefs = await SharedPreferences.getInstance();
  final userToken = await _secureStorage.safeRead('token');
  if (userToken != null) {
    await prefs.remove('notif_ids_${userToken}_$medicineName');
  }
}

int safeNotificationId(int id) {
  return id.abs() & 0x7FFFFFFF;
}
