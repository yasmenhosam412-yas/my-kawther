import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/auth/models/register.dart';
import 'package:elkawther/features/auth/services/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  AuthCubit({required this.authService}) : super(AuthInitial());

  void userVisitor() {
    emit(const AuthVisitor());
  }

  Future<bool> restoreSession() async {
    final hasSession = await authService.hasStoredSession();
    if (hasSession) {
      emit(AuthLoadedLogin());
      return true;
    }

    emit(AuthInitial());
    return false;
  }

  Future<void> logout() async {
    await authService.logout();
    emit(AuthInitial());
  }

  Future<void> deleteAccount() async {
    await authService.deleteAccount();
    emit(AuthInitial());
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await authService.login(email, password);
      emit(AuthLoadedLogin());
    } catch (error) {
      emit(AuthErrorLogin(error: _toErrors(error)));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) async {
    emit(AuthLoading());
    try {
      await authService.register(
        RegisterRequest(
          name: name,
          email: email,
          password: password,
          phone: phone ?? "",
          passwordConfirmation: confirmPassword,
        ),
      );
      emit(AuthLoadedRegister());
    } catch (error) {
      emit(AuthErrorRegister(error: _toErrors(error)));
    }
  }

  Errors _toErrors(Object error) {
    if (error is Errors) return error;
    if (error is DioException) return Errors.fromDioError(error);
    return const Errors(message: 'unexpectedNetworkError');
  }
}
