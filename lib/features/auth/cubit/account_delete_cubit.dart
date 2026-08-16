import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';

part 'account_delete_state.dart';

class AccountDeleteCubit extends Cubit<AccountDeleteState> {
  final AuthService authService;
  final SecureStorageHelper storageHelper = SecureStorageHelper();

  AccountDeleteCubit(this.authService) : super(AccountDeleteInitial());

  Future<void> deleteAccount() async {
    emit(AccountDeleteLoading());
    try {
      final result = await authService.deleteAccount();

      await result.fold(
        (l) async {
          emit(AccountDeleteError(error: l));
        },
        (r) async {
          await storageHelper.delete("token");
          await storageHelper.delete("isLoggedIn");
          await storageHelper.delete("email");
          await storageHelper.delete("phone");
          await storageHelper.delete("userId");
          await storageHelper.delete("name");

          if (GetIt.I.isRegistered<FavouriteCubit>()) {
            GetIt.I<FavouriteCubit>().clearFavorites();
          }

          emit(AccountDeleteLoaded());
        },
      );
    } catch (e) {
      emit(AccountDeleteError(error: Errors(message: e.toString())));
    }
  }
}
