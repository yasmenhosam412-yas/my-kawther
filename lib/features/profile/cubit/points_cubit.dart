import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/profile/services/loyalty_service.dart';
import 'package:elkawther/features/profile/services/profile_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/features/profile/models/points_response.dart';

class PointsCubit extends Cubit<PointsState> {
  final ProfileServices profileServices;
  final LoyaltyService loyaltyService;

  PointsCubit(this.profileServices, this.loyaltyService)
    : super(PointsStateInitial());

  int loyaltyBalance = 0;
  String loyaltyRules = '';
  List<LoyaltyReward> rewards = const [];
  List<OrderPoints> expiring = const [];
  List<OrderPoints> redemptions = const [];

  Future<void> loadOverview() async {
    try {
      final account = await loyaltyService.account();
      loyaltyBalance = account.balance;
      loyaltyRules = account.rules;
    } catch (_) {}
    try {
      rewards = await loyaltyService.rewards();
    } catch (_) {}
    try {
      expiring = _asPoints(await loyaltyService.expiring());
    } catch (_) {}
    try {
      redemptions = _asPoints(
        await loyaltyService.redemptions(status: 'pending'),
      );
    } catch (_) {}
    await getUserPointsValid();
  }

  Future<LoyaltyReward> rewardDetails(int id) => loyaltyService.reward(id);

  Future<Map<String, dynamic>> redemptionDetails(int id) =>
      loyaltyService.redemption(id);

  List<OrderPoints> _asPoints(List<Map<String, dynamic>> rows) {
    return rows.map(OrderPoints.fromJson).toList();
  }

  Future<String> redeem(int rewardId) async {
    try {
      final message = await loyaltyService.redeemReward(rewardId);
      loyaltyBalance = (await loyaltyService.account()).balance;
      rewards = await loyaltyService.rewards();
      await getUserPointsValid();
      return message;
    } on DioException catch (error) {
      throw Errors.fromDioError(error);
    }
  }

  Future<void> getUserPointsNotValid() async {
    emit(PointsStateLoading());
    try {
      final orders = await profileServices.getPointsNotValid();
      _emitOrders(orders);
    } catch (error) {
      emit(PointsStateError(error: Errors(message: _getErrorMessage(error))));
    }
  }

  Future<void> getUserPointsValid() async {
    emit(PointsStateLoading());
    try {
      final orders = await profileServices.getPointsValid();
      _emitOrders(orders);
    } catch (error) {
      emit(PointsStateError(error: Errors(message: _getErrorMessage(error))));
    }
  }

  Future<void> getUserPointsExpired() async {
    emit(PointsStateLoading());
    try {
      final orders = await profileServices.getPointsExpired();
      _emitOrders(orders);
    } catch (error) {
      emit(PointsStateError(error: Errors(message: _getErrorMessage(error))));
    }
  }

  Future<void> getUserPointsHistory() async {
    emit(PointsStateLoading());
    try {
      List<OrderPoints> rows = [];
      try {
        rows = _asPoints(await loyaltyService.history(perPage: 20));
      } catch (_) {}
      if (rows.isEmpty) {
        rows = (await profileServices.getPointsHistory()).orders;
      }
      _emitOrders(PointsResponse(totalPoints: loyaltyBalance, orders: rows));
    } catch (error) {
      emit(PointsStateError(error: Errors(message: _getErrorMessage(error))));
    }
  }

  void _emitOrders(PointsResponse orders) {
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
        loyaltyBalance: loyaltyBalance,
        loyaltyRules: loyaltyRules,
        rewards: rewards,
        expiring: expiring,
        redemptions: redemptions,
      ),
    );
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

      if (data is Map && data["message"] != null) {
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
  final int loyaltyBalance;
  final String loyaltyRules;
  final List<LoyaltyReward> rewards;
  final List<OrderPoints> expiring;
  final List<OrderPoints> redemptions;

  PointsStateLoaded({
    required this.orders,
    required this.total,
    this.pointsExpires,
    this.pointsRedeemed,
    this.expiredAt,
    this.loyaltyBalance = 0,
    this.loyaltyRules = '',
    this.rewards = const [],
    this.expiring = const [],
    this.redemptions = const [],
  });
}

class PointsStateError extends PointsState {
  final Errors error;

  PointsStateError({required this.error});
}
