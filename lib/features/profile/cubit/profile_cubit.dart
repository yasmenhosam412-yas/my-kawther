import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/profile/models/user_model.dart';
import 'package:elkawther/features/profile/services/profile_services.dart';
import 'package:elkawther/features/profile/data/profile_local_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/features/checkout/models/delivery_prices.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/models/setting_response.dart';

class ProfileCubit extends Cubit<ProfileCubitState> {
  final ProfileServices profileServices;

  ProfileCubit(this.profileServices) : super(ProfileCubitInitialState());

  List<DeliveryPrice>? deliveryPrices;
  UserModel? userData;

  void clearUser() {
    userData = null;
    emit(ProfileCubitInitialState());
  }

  Future<void> getUserData() async {
    userData = null;
    emit(ProfileUserLoadingState());
    try {
      final user = await profileServices.fetchUserData();
      if (user == null) {
        userData = null;
        emit(ProfileUserUnavailableState());
        return;
      }
      userData = user;
      ProfileLocalStore.instance
        ..name = user.name
        ..email = user.email
        ..phone = user.phone;
      emit(ProfileUserLoadedState(user));
    } catch (error) {
      final message = error is DioException
          ? Errors.fromDioError(error)
          : Errors(message: _getErrorMessage(error));
      emit(ProfileUserErrorState(message: message));
    }
  }

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.connectionError) {
        return "nointernet";
      }

      final data = error.response?.data;

      if (data is Map<String, dynamic> && data["errors"] != null) {
        final errors = data["errors"] as Map;
        for (var key in ["email", "phone", "name"]) {
          if (errors.containsKey(key) &&
              errors[key] is List &&
              (errors[key] as List).isNotEmpty) {
            return (errors[key] as List).first.toString();
          }
        }
      }

      return error.message ?? "Unexpected server error";
    }

    return error.toString();
  }

  Future<void> editDataUser(
    int id,
    String? email,
    String? name,
    String? phone,
    BuildContext context,
  ) async {
    try {
      final updated = await profileServices.editData(id, email, name, phone);
      final current = userData;
      final model = UserModel(
        id: updated != null && updated.id != 0 ? updated.id : id,
        name: _updatedField(updated?.name, name, current?.name),
        phone: _updatedField(updated?.phone, phone, current?.phone),
        email: _updatedField(updated?.email, email, current?.email),
        password: updated?.password ?? current?.password,
        socialId: updated?.socialId ?? current?.socialId,
        socialProvider: updated?.socialProvider ?? current?.socialProvider,
        isVerified: updated?.isVerified ?? current?.isVerified ?? false,
        otpCode: updated?.otpCode ?? current?.otpCode,
        otpExpiresAt: updated?.otpExpiresAt ?? current?.otpExpiresAt,
        createdAt: _updatedField(updated?.createdAt, null, current?.createdAt),
        updatedAt: _updatedField(updated?.updatedAt, null, current?.updatedAt),
      );
      _applyUser(model);
    } catch (error) {
      if (context.mounted) {
        emit(
          ProfileEditErrorState(
            message: error is DioException
                ? Errors.fromDioError(error)
                : Errors(message: _getErrorMessage(error)),
          ),
        );
      }
    }
  }

  String _updatedField(String? fromResponse, String? submitted, String? current) {
    if (fromResponse != null && fromResponse.trim().isNotEmpty) {
      return fromResponse;
    }
    if (submitted != null && submitted.trim().isNotEmpty) return submitted;
    return current ?? '';
  }

  void _applyUser(UserModel user) {
    userData = user;
    ProfileLocalStore.instance
      ..name = user.name
      ..email = user.email
      ..phone = user.phone;
    emit(ProfileUserLoadedState(user));
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    BuildContext context,
  ) async {
    emit(ProfileCubitLoadingState());
    try {
      final message = await profileServices.changePass(
        currentPassword,
        newPassword,
      );
      emit(ProfileEditPassSuccessState(message: message));
    } catch (error) {
      emit(
        ProfileEditErrorState(
          message: Errors(message: _getErrorMessage(error)),
        ),
      );
    }
  }

  Future<void> contactUS(String name, String email, String messageUser) async {
    emit(ProfileCubitLoadingState());
    try {
      final message = await profileServices.contactUs(name, email, messageUser);
      emit(
        ProfileContactUsSuccessState(
          message: Errors(message: message.toString()),
        ),
      );
    } catch (error) {
      emit(
        ProfileContactUsErrorState(
          message: Errors(message: _getErrorMessage(error)),
        ),
      );
    }
  }

  Future<void> getSettings() async {
    emit(ProfileCubitLoadingState());
    try {
      final settings = await profileServices.fetchSettings();
      emit(ProfileSettingsLoadedState(settings));
    } catch (error) {
      emit(
        ProfileSettingsErrorState(
          message: Errors(message: _getErrorMessage(error)),
        ),
      );
    }
  }

  Future<void> getDeliveryPricesAndCities() async {
    emit(ProfileCubitLoadingState());
    try {
      deliveryPrices = await profileServices.getDeliveryPricesAndCities();
      emit(ProfileCubitDeliveryPricesState(deliveryPrices: deliveryPrices!));
    } catch (error) {
      emit(
        ProfileCubitDeliveryPricesErrorState(
          message: Errors(message: _getErrorMessage(error)),
        ),
      );
    }
  }
}

abstract class ProfileCubitState {}

class ProfileCubitInitialState extends ProfileCubitState {}

class ProfileCubitLoadingState extends ProfileCubitState {}

class ProfileUserLoadingState extends ProfileCubitState {}

class ProfileUserLoadedState extends ProfileCubitState {
  final UserModel user;

  ProfileUserLoadedState(this.user);
}

class ProfileUserUnavailableState extends ProfileCubitState {}

class ProfileUserErrorState extends ProfileCubitState {
  final Errors message;

  ProfileUserErrorState({required this.message});
}

class ProfileCubitDeliveryPricesState extends ProfileCubitState {
  final List<DeliveryPrice> deliveryPrices;

  ProfileCubitDeliveryPricesState({required this.deliveryPrices});
}

class ProfileCubitDeliveryPricesErrorState extends ProfileCubitState {
  final Errors message;

  ProfileCubitDeliveryPricesErrorState({required this.message});
}

class ProfileCubitLoadedEditUSerDataState extends ProfileCubitState {
  final UserModel userModel;

  ProfileCubitLoadedEditUSerDataState(this.userModel);
}

class ProfileEditSuccessState extends ProfileCubitState {}

class ProfileEditPassSuccessState extends ProfileCubitState {
  final String message;

  ProfileEditPassSuccessState({required this.message});
}

class ProfileEditErrorState extends ProfileCubitState {
  final Errors? message;

  ProfileEditErrorState({this.message});
}

class ProfileContactUsSuccessState extends ProfileCubitState {
  final Errors message;

  ProfileContactUsSuccessState({required this.message});
}

class ProfileContactUsErrorState extends ProfileCubitState {
  final Errors message;

  ProfileContactUsErrorState({required this.message});
}

class ProfileSettingsLoadedState extends ProfileCubitState {
  final SettingsResponse settings;

  ProfileSettingsLoadedState(this.settings);
}

class ProfileSettingsErrorState extends ProfileCubitState {
  final Errors message;

  ProfileSettingsErrorState({required this.message});
}

extension DeliveryPriceExtension on ProfileCubit {
  double? getDeliveryPriceForAddress(AddressModel? address) {
    if (address == null) return null;
    if (address.isPickupFromPharmacy) return 0;
    if (deliveryPrices == null) return null;

    final names = [address.governorate, address.city]
        .whereType<String>()
        .map((name) => name.trim().toLowerCase())
        .where((name) => name.isNotEmpty)
        .toSet();
    for (final price in deliveryPrices!) {
      if (names.contains(price.governorate.trim().toLowerCase())) {
        return double.tryParse(price.price.replaceAll(',', '')) ?? 0;
      }
    }
    return null;
  }
}
