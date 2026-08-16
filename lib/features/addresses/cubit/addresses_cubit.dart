import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/services/profile_services.dart';
import 'package:dio/dio.dart';

// ---------------- Address Cubit ----------------
class AddressCubit extends Cubit<AddressCubitState> {
  final ProfileServices profileServices;

  AddressCubit(this.profileServices) : super(AddressInitialState());

  List<AddressModel>? addresses;

  void setAddresses(List<AddressModel> updatedAddresses) {
    addresses = updatedAddresses;
    emit(AddressLoadedState(addresses: updatedAddresses));
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
      if (data is Map<String, dynamic> && data.containsKey("message")) {
        return data["message"].toString();
      } else if (data is String) {
        return data;
      } else if (data is Map<String, dynamic> && data["errors"] != null) {
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

  // ---------------- CRUD Operations ----------------

  Future<void> getAllAddresses(BuildContext context) async {
    emit(AddressLoadingState());
    try {
      final model = await profileServices.getAllAddresses(10, 0, "ASC", "id");
      addresses = model;
      emit(AddressLoadedState(addresses: List<AddressModel>.from(addresses!)));
    } catch (error) {
      if (context.mounted) {
        emit(
          AddressErrorState(message: Errors(message: _getErrorMessage(error))),
        );
      }
    }
  }

  Future<void> addAddress(
    String address,
    String gov,
    String city,
    String street,
    String landMark,
    String type,
    String apartment,
    BuildContext context,
  ) async {
    emit(AddressLoadingState());
    try {
      final model = await profileServices.addNewAddress(
        address: address,
        city: city,
        gov: gov,
        landMark: landMark,
        street: street,
        type: type,
        apartment: apartment,
      );

      final updatedAddresses = List<AddressModel>.from(addresses ?? []);
      updatedAddresses.add(model.first);
      addresses = updatedAddresses;

      emit(AddressAddedLoadedState(addresses: updatedAddresses));
    } catch (error) {
      if (context.mounted) {
        emit(
          AddressErrorState(message: Errors(message: _getErrorMessage(error))),
        );
      }
    }
  }

  Future<void> editAddress(
    int id,
    String? address,
    String? gov,
    String? city,
    String? apartment,
    String? landMark,
    String? type,
    String? street,
    BuildContext context,
  ) async {
    emit(AddressLoadingState());
    try {
      final editedAddressList = await profileServices.editAddress(
        id: id,
        type: type,
        landMark: landMark,
        gov: gov,
        city: city,
        street: street,
        apartment: apartment,
        address: address,
      );

      final updatedAddresses = List<AddressModel>.from(addresses ?? []);
      final index = updatedAddresses.indexWhere((addr) => addr.id == id);
      if (index != -1) updatedAddresses[index] = editedAddressList.first;

      addresses = updatedAddresses;
      emit(AddressEditedLoadedState(addresses: updatedAddresses));
    } catch (error) {
      if (context.mounted) {
        emit(
          AddressErrorState(message: Errors(message: _getErrorMessage(error))),
        );
      }
    }
  }

  Future<void> deleteAddress(int id, BuildContext context) async {
    emit(AddressLoadingState());
    try {
      await profileServices.deleteAddress(id: id);

      final updatedAddresses =
          (addresses ?? []).where((address) => address.id != id).toList();
      addresses = updatedAddresses;

      emit(AddressLoadedState(addresses: updatedAddresses));
    } catch (error) {
      if (context.mounted) {
        emit(
          AddressErrorState(message: Errors(message: _getErrorMessage(error))),
        );
      }
    }
  }

  Future<void> toggleDefaultAddress(int id, BuildContext context) async {
    try {
      final updatedAddresses =
          (addresses ?? []).map((address) {
            if (address.id == id) return address.copyWith(isDefault: true);
            if (address.isDefault) return address.copyWith(isDefault: false);
            return address;
          }).toList();

      addresses = updatedAddresses;
      emit(AddressLoadedState(addresses: updatedAddresses));

      await profileServices.toggleDefultAddress(id: id);
    } catch (error) {
      if (context.mounted) {
        emit(
          AddressErrorState(message: Errors(message: _getErrorMessage(error))),
        );
      }
    }
  }

  AddressModel? getDefaultAddress() {
    if (addresses == null) return null;
    try {
      return addresses!.firstWhere((address) => address.isDefault);
    } catch (e) {
      return null;
    }
  }
}

// ---------------- Address Cubit States ----------------
abstract class AddressCubitState {}

class AddressInitialState extends AddressCubitState {}

class AddressLoadingState extends AddressCubitState {}

class AddressLoadedState extends AddressCubitState {
  final List<AddressModel> addresses;

  AddressLoadedState({required this.addresses});
}

class AddressAddedLoadedState extends AddressCubitState {
  final List<AddressModel> addresses;

  AddressAddedLoadedState({required this.addresses});
}

class AddressEditedLoadedState extends AddressCubitState {
  final List<AddressModel> addresses;

  AddressEditedLoadedState({required this.addresses});
}

class AddressErrorState extends AddressCubitState {
  final Errors message;

  AddressErrorState({required this.message});
}
