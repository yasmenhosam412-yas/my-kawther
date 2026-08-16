import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required TimeOfDay timeOfDay,
  required List<String> days,
}) async {
  final location = tz.getLocation('Africa/Cairo');

  for (final day in days) {
    final dayIndex = _getWeekdayIndex(day);
    final scheduledDate = _nextInstanceOfDay(timeOfDay, dayIndex, location);

    if (scheduledDate.isBefore(tz.TZDateTime.now(location))) {
      continue;
    }

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   notificationId++,
    //   title,
    //   body,
    //   scheduledDate,
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'dose_channel_id',
    //       'Dose Reminders',
    //       importance: Importance.max,
    //       priority: Priority.high,
    //     ),
    //   ),
    //   androidAllowWhileIdle: true,
    //   matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    //   uiLocalNotificationDateInterpretation:
    //   UILocalNotificationDateInterpretation.absoluteTime,
    // );
  }
}

int _getWeekdayIndex(String day) {
  switch (day.toLowerCase()) {
    case 'saturday':
      return DateTime.saturday;
    case 'sunday':
      return DateTime.sunday;
    case 'monday':
      return DateTime.monday;
    case 'tuesday':
      return DateTime.tuesday;
    case 'wednesday':
      return DateTime.wednesday;
    case 'thursday':
      return DateTime.thursday;
    case 'friday':
      return DateTime.friday;
    default:
      return DateTime.monday;
  }
}

tz.TZDateTime _nextInstanceOfDay(
  TimeOfDay time,
  int weekday,
  tz.Location location,
) {
  final now = tz.TZDateTime.now(location);
  var scheduledDate = tz.TZDateTime(
    location,
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  return scheduledDate;
}
