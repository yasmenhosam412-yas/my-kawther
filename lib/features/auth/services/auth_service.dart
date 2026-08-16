import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:elkawther/features/auth/models/login.dart';
import 'package:elkawther/features/auth/models/register.dart';
import 'package:elkawther/core/services/dio_service.dart';

class AuthService {
  final Dio _dio = DioService.dio;
  final SecureStorageHelper secureStorageHelper = SecureStorageHelper();

  Future<Either<Errors, LoginResponse>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        "/api/v1/user/login",
        data: {"email": username, "password": password},
      );

      final data = response.data;

      if (data.containsKey("original")) {
        final original = data['original'];

        if (original['token'] == null || original['user'] == null) {
          final message = original['message']?.toString() ?? "Login failed";
          return Left(Errors(message: message));
        }

        final user = original['user'];
        final token = original['token'];

        final loginResponse = LoginResponse(
          token: token.toString(),
          userId: user['id'] as int?,
          userName: user['name']?.toString(),
          email: user['email']?.toString(),
          phone: user['phone']?.toString(),
        );

        return Right(loginResponse);
      } else {
        return Left(Errors.fromJson(data));
      }
    } on DioError catch (e) {
      return Left(Errors.fromDioError(e));
    } catch (e) {
      return Left(Errors(message: e.toString()));
    }
  }

  Future<Either<Errors, RegisterResponse>> register(
    RegisterRequest registerRequest,
  ) async {
    try {
      final response = await _dio.post(
        "/api/v1/user/register",
        data: registerRequest.toJson(),
      );

      final data = response.data;

      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        if (data.containsKey("original")) {
          return Left(Errors.fromJson(data));
        }
        return Right(RegisterResponse.fromJson(data));
      }

      return Left(
        Errors.fromJson(
          data is Map<String, dynamic>
              ? data
              : {"message": "Unexpected response"},
        ),
      );
    } on DioError catch (e) {
      return Left(Errors.fromDioError(e));
    } catch (e) {
      return Left(Errors(message: e.toString()));
    }
  }

  Future<Either<Errors, Map<String, dynamic>>> resetPassword(
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await _dio.post(
        "/api/v1/password/reset/auth",
        data: {
          "email": email,
          "password": password,
          "password_confirmation": confirmPassword,
        },
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        if (data.containsKey("message") &&
            (data["message"] == "email not found." ||
                data["message"].toString().toLowerCase().contains("error"))) {
          return Left(Errors.fromJson(data));
        }

        return Right(data);
      }

      return Left(
        Errors.fromJson(const {"message": "Unexpected response format"}),
      );
    } on DioError catch (e) {
      return Left(Errors.fromDioError(e));
    } catch (e) {
      return Left(Errors(message: e.toString()));
    }
  }

  Future<void> logout(String token) async {
    try {
      await _dio.post(
        "/api/v1/logout",
        data: {"fcm-token": await secureStorageHelper.safeRead('fcm_token')},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (_) {}
  }

  Future<Either<String, void>> saveFCMtoken() async {
    try {
      final fcmToken = await secureStorageHelper.safeRead('fcm_token');
      await _dio.post("/api/save-fcm-token", data: {"fcm_token": fcmToken});
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<Errors, void>> deleteAccount() async {
    try {
      final userId = await secureStorageHelper.safeRead('userId');

      if (userId == null || userId.isEmpty) {
        return const Left(Errors(message: 'User not found'));
      }

      await _dio.delete("/api/v1/user/delete/$userId");

      return const Right(null);
    } on DioException catch (e) {
      return Left(Errors.fromDioError(e));
    } catch (e) {
      return Left(Errors(message: e.toString()));
    }
  }
}
