import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/profile/services/profile_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/features/profile/models/points_response.dart';

class PointsCubit extends Cubit<PointsState> {
  final ProfileServices profileServices;

  PointsCubit(this.profileServices) : super(PointsStateInitial());

  Future<void> getUserPointsNotValid() async {
    emit(PointsStateLoading());
    try {
      final orders = await profileServices.getPointsNotValid();
      emit(
        PointsStateLoaded(
          orders: orders.orders,
          total: orders.totalPoints,
          pointsExpires:
              orders.orders.isNotEmpty ? orders.orders.first.expiresAt : null,
          pointsRedeemed:
              orders.orders.isNotEmpty ? orders.orders.first.redeemedAt : null,
          expiredAt:
              orders.orders.isNotEmpty ? orders.orders.first.expiredAt : null,
        ),
      );
    } catch (error) {
      emit(PointsStateError(error: Errors(message: _getErrorMessage(error))));
    }
  }

  Future<void> getUserPointsValid() async {
    emit(PointsStateLoading());
    try {
      final orders = await profileServices.getPointsValid();
      emit(
        PointsStateLoaded(
          orders: orders.orders,
          total: orders.totalPoints,
          pointsExpires:
              orders.orders.isNotEmpty ? orders.orders.first.expiresAt : null,
          pointsRedeemed:
              orders.orders.isNotEmpty ? orders.orders.first.redeemedAt : null,
          expiredAt:
              orders.orders.isNotEmpty ? orders.orders.first.expiredAt : null,
        ),
      );
    } catch (error) {
      emit(PointsStateError(error: Errors(message: _getErrorMessage(error))));
    }
  }

  Future<void> getUserPointsExpired() async {
    emit(PointsStateLoading());
    try {
      final orders = await profileServices.getPointsExpired();
      emit(
        PointsStateLoaded(
          orders: orders.orders,
          total: orders.totalPoints,
          pointsExpires:
              orders.orders.isNotEmpty ? orders.orders.first.expiresAt : null,
          pointsRedeemed:
              orders.orders.isNotEmpty ? orders.orders.first.redeemedAt : null,
          expiredAt:
              orders.orders.isNotEmpty ? orders.orders.first.expiredAt : null,
        ),
      );
    } catch (error) {
      emit(PointsStateError(error: Errors(message: _getErrorMessage(error))));
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
}

abstract class PointsState {}

class PointsStateInitial extends PointsState {}

class PointsStateLoading extends PointsState {}

class PointsStateLoaded extends PointsState {
  final List<OrderPoints> orders;
  final int total;
  final DateTime? pointsExpires;
  final DateTime? pointsRedeemed;
  final DateTime? expiredAt;

  PointsStateLoaded({
    required this.orders,
    required this.total,
    this.pointsExpires,
    this.pointsRedeemed,
    this.expiredAt,
  });
}

class PointsStateError extends PointsState {
  final Errors error;

  PointsStateError({required this.error});
}
