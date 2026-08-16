import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:elkawther/core/constants/app_constants.dart';
import 'package:elkawther/core/services/auth_interceptor.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioService {
  static final Dio dio = GetIt.I.get<Dio>();

  static Future<void> init() async {
    final langCode = GetIt.I.get<SharedPreferences>().getString('lang') ?? 'ar';
    final SecureStorageHelper storageHelper = SecureStorageHelper();
    String? token;

    try {
      token = await storageHelper.safeRead('token');
    } catch (e) {
      if (e.toString().contains('BAD_DECRYPT') ||
          e.toString().contains('PlatformException')) {
        debugPrint('Secure storage corrupted, clearing all keys...');
        await storageHelper.clearAll();
        token = null;
      } else {
        debugPrint('Unexpected secure storage error: $e');
      }
    }

    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      dio.httpClientAdapter = NativeAdapter(
        createFallbackAdapter: (error, stackTrace) => IOHttpClientAdapter(),
      );
    }

    dio.options
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..baseUrl = AppConstants.baseUrl
      ..headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Accept-Language": langCode,
        "Authorization":
            (token != null && token.isNotEmpty) ? 'Bearer $token' : '',
      };

    dio.interceptors.add(GetIt.I.get<AuthenticatorInterceptor>());

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  static void updateLanguageHeader(String langCode) {
    dio.options.headers["Accept-Language"] = langCode;
  }
}
