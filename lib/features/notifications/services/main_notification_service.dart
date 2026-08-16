import 'package:dio/dio.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:elkawther/features/notifications/models/notification_model.dart';

import 'package:elkawther/core/services/dio_service.dart';

class MainNotiService {
  final Dio _dio = DioService.dio;
  final SecureStorageHelper secureStorageHelper = SecureStorageHelper();

  Future<List<NotificationModel>> getUserNotification() async {
    final result = await _dio.get("/api/v1/user/notifications");
    final rawData = result.data['data'] as List;
    return rawData.map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<bool> markAsRead(int notiId) async {
    await _dio.post("/api/v1/user/notifications/$notiId/read");
    return true;
  }

  Future<bool> readAll() async {
    await _dio.post("/api/v1/user/notifications/read-all");
    return true;
  }
}
