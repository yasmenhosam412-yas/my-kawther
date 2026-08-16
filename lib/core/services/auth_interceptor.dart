import 'package:dio/dio.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class AuthenticatorInterceptor extends Interceptor {
  final SecureStorageHelper _secureStorage;

  AuthenticatorInterceptor() : _secureStorage = GetIt.I<SecureStorageHelper>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _secureStorage.safeRead('token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      super.onRequest(options, handler);
    } catch (e) {
      debugPrint('Error while reading token: $e');
      super.onRequest(options, handler);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {}

    super.onError(err, handler);
  }
}
