import 'package:elkawther/core/toasts/toasts.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:elkawther/features/auth/models/login.dart';
import 'package:elkawther/features/auth/models/register.dart';
import 'package:elkawther/features/auth/services/auth_service.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  passChanged,
  registerSuccess,
  registerError,
  accountDeleted,
  errorDeleted,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? userName;
  final Errors? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userName,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userName,
    Errors? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, userName, errorMessage];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState()) {
    loadUser();
  }

  final _authService = GetIt.I<AuthService>();
  final SecureStorageHelper storageHelper = SecureStorageHelper();

  Future<void> loadUser() async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final token = await storageHelper.safeRead("token");

      final name = await storageHelper.safeRead("name");

      if (token != null && token.isNotEmpty) {
        emit(state.copyWith(status: AuthStatus.authenticated, userName: name));
      } else {
        emit(const AuthState(status: AuthStatus.unauthenticated));
      }
    } catch (_) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login(
    String username,
    String password,
    BuildContext context,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final loginResult = await _authService.login(username, password);

      loginResult.fold(
        (error) {
          final msg = error.message;

          emit(
            state.copyWith(
              status: AuthStatus.error,
              errorMessage: Errors(message: msg),
            ),
          );

          ToastMessage().displayMessageToast(
            state.errorMessage?.localizedMessage(context) ?? msg,
            Colors.red.shade800,
          );
        },

        (loginResponse) async {
          await _saveUserData(loginResponse);

          final userName =
              loginResponse.userName ?? loginResponse.email ?? "User";

          await _authService.saveFCMtoken();
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              userName: userName,
              errorMessage: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: Errors(message: S.current.unexpectedError),
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final token = await storageHelper.safeRead("token");
      if (token != null) {
        await _authService.logout(token);
      }

      await storageHelper.delete("token");
      await storageHelper.delete("isLoggedIn");
      await storageHelper.delete("email");
      await storageHelper.delete("phone");
      await storageHelper.delete("userId");
      await storageHelper.delete("name");

      if (GetIt.I.isRegistered<FavouriteCubit>()) {
        GetIt.I<FavouriteCubit>().clearFavorites();
      }

      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: Errors(message: S.current.unexpectedError),
        ),
      );
    }
  }

  Future<void> register(RegisterRequest request, BuildContext context) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final result = await _authService.register(request);

      result.fold(
        (error) {
          emit(
            state.copyWith(
              status: AuthStatus.registerError,
              errorMessage: Errors(message: error.message),
            ),
          );
          ToastMessage().displayMessageToast(
            state.errorMessage!.localizedMessage(context),
            Colors.red.shade800,
          );
        },
        (_) {
          emit(state.copyWith(status: AuthStatus.registerSuccess));
        },
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: Errors(message: S.current.unexpectedError),
        ),
      );
    }
  }

  Future<void> resetPassword(
    String email,
    String pass,
    String repass,
    BuildContext context,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authService.resetPassword(email, pass, repass);

    result.fold((error) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: Errors(message: error.message),
        ),
      );
      ToastMessage().displayMessageToast(
        state.errorMessage!.localizedMessage(context),
        Colors.red.shade800,
      );
    }, (_) => emit(const AuthState(status: AuthStatus.passChanged)));
  }

  Future<void> _saveUserData(LoginResponse loginResponse) async {
    await storageHelper.safeWrite("token", loginResponse.token);
    await storageHelper.safeWrite("isLoggedIn", "true");
    await storageHelper.safeWrite("email", loginResponse.email);

    if (loginResponse.phone != null) {
      await storageHelper.safeWrite("phone", loginResponse.phone);
    }

    if (loginResponse.userId != null) {
      await storageHelper.safeWrite("userId", loginResponse.userId.toString());
    }

    if (loginResponse.userName != null) {
      await storageHelper.safeWrite("name", loginResponse.userName);
    }
  }
}
