import 'package:dio/dio.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:elkawther/features/auth/models/login.dart';
import 'package:elkawther/features/auth/models/register.dart';
import 'package:elkawther/core/services/dio_service.dart';

class AuthService {
  final Dio _dio = DioService.dio;
  final SecureStorageHelper secureStorageHelper = SecureStorageHelper();

  Future<LoginResponse> login(String email, String password) async {
    final response = await _dio.post(
      "/api/user/login",
      data: {'email': email, 'password': password},
    );
    final loginResponse = LoginResponse.fromJson(response.data);
    await secureStorageHelper.safeWrite('token', loginResponse.token);
    return loginResponse;
  }

  Future<RegisterResponse> register(RegisterRequest registerRequest) async {
    final response = await _dio.post(
      "/api/user/register",
      data: registerRequest.toJson(),
    );
    return RegisterResponse.fromJson(response.data);
  }

  Future<bool> hasStoredSession() async {
    final token = await secureStorageHelper.safeRead('token');
    return token != null && token.trim().isNotEmpty;
  }

  Future<void> resetPassword(
    String email,
    String password,
    String confirmPassword,
  ) async {}

  Future<void> logout() => secureStorageHelper.delete('token');

  Future<void> saveFCMtoken() async {}

  Future<void> deleteAccount() async {}
}
