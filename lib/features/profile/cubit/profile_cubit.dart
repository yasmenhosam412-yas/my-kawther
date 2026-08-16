import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/profile/models/user_model.dart';
import 'package:elkawther/features/profile/services/profile_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/features/checkout/models/delivery_prices.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/models/setting_response.dart';

class ProfileCubit extends Cubit<ProfileCubitState> {
  final ProfileServices profileServices;

  ProfileCubit(this.profileServices) : super(ProfileCubitInitialState());

  List<DeliveryPrice>? deliveryPrices;

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
    emit(ProfileCubitLoadingState());
    try {
      final model = await profileServices.editData(id, email, name, phone);
      emit(ProfileCubitLoadedEditUSerDataState(model));
      emit(ProfileEditSuccessState());
    } catch (error) {
      if (context.mounted) {
        emit(
          ProfileEditErrorState(
            message: Errors(message: _getErrorMessage(error)),
          ),
        );
      }
    }
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
    if (address == null || deliveryPrices == null) return null;

    final deliveryPrice = deliveryPrices!.firstWhere(
      (price) =>
          price.governorate.toLowerCase() == address.city?.toLowerCase() ||
          price.governorate.toLowerCase() == address.city?.toLowerCase(),
      orElse:
          () => DeliveryPrice(
            governorate: address.governorate ?? "",
            price: "0",
            id: 0,
          ),
    );

    return double.tryParse(deliveryPrice.price) ?? 0.0;
  }
}
