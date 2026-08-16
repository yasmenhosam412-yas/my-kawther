import 'dart:io';
import 'package:dio/dio.dart';
import 'package:elkawther/features/orders/models/all_returns.dart';
import 'package:elkawther/features/orders/models/track_order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:elkawther/features/orders/models/orders_model.dart';
import 'package:elkawther/features/orders/models/refund_order.dart';
import 'package:elkawther/features/orders/services/orders_services.dart';

enum OrderStatus { pending, completed, canceled, confirmed, delivery }

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersServices ordersServices;

  OrdersCubit(this.ordersServices) : super(OrdersInitial());

  Future<void> getOrdersByStatus(OrderStatus status) async {
    emit(OrdersLoading());
    try {
      final response = await ordersServices.getGroupedOrders();
      List<Order> orders = [];

      switch (status) {
        case OrderStatus.pending:
          orders = response.data.pending;
          break;
        case OrderStatus.completed:
          orders = response.data.completed;
          break;
        case OrderStatus.canceled:
          orders = response.data.canceled;
          break;
        case OrderStatus.confirmed:
          orders = response.data.confirmed;
          break;
        case OrderStatus.delivery:
          orders = response.data.onDelivery;
          break;
      }

      emit(OrdersLoaded(orders));
    } on DioException catch (e) {
      emit(OrdersError(Errors.fromDioError(e)));
    } catch (e) {
      emit(OrdersError(Errors(message: e.toString())));
    }
  }

  Future<void> getOrderDetails(int id) async {
    emit(OrdersLoading());
    try {
      final OrderDetailsModel orderDetails = await ordersServices
          .getOrderDetails(id);
      emit(OrderDetailsLoaded(orderDetails));
    } on DioException catch (e) {
      emit(OrdersError(Errors.fromDioError(e)));
    } catch (e) {
      emit(OrdersError(Errors(message: e.toString())));
    }
  }

  Future<void> getOrderDetailsRefunded(int id) async {
    emit(OrdersLoading());
    try {
      final RefundedItem orderDetails = await ordersServices
          .getOrderDetailsRefunded(id);
      emit(OrderDetailsRefnudedLoaded(orderDetails));
    } on DioException catch (e) {
      emit(OrdersError(Errors.fromDioError(e)));
    } catch (e) {
      emit(OrdersError(Errors(message: e.toString())));
    }
  }

  Future<void> getOrderTrack(int id) async {
    emit(OrdersLoading());
    try {
      final TrackOrder trackOrder = await ordersServices.getOrderTracking(id);
      emit(OrderTrackLoaded(trackOrder));
    } on DioException catch (e) {
      emit(OrdersError(Errors.fromDioError(e)));
    } catch (e) {
      emit(OrdersError(Errors(message: e.toString())));
    }
  }

  Future<void> getCombinedPendingAndConfirmedOrders() async {
    emit(OrdersLoading());
    try {
      final response = await ordersServices.getGroupedOrders();

      final delivery = response.data.onDelivery;
      final confirmed = response.data.confirmed;
      final pending = response.data.pending;

      emit(OrdersLoaded([...delivery, ...confirmed, ...pending]));
    } on DioException catch (e) {
      emit(OrdersError(Errors.fromDioError(e)));
    } catch (e) {
      emit(OrdersError(Errors(message: e.toString())));
    }
  }

  Future<void> requestRefund({
    required int orderId,
    required String reason,
    String? note,
    required String refundAmount,
    required String refundMethod,
    required String address,
    required List<File> images,
  }) async {
    emit(OrdersLoading());
    try {
      final response = await ordersServices.refundRequest(
        orderId,
        reason,
        note,
        refundAmount,
        refundMethod,
        address,
        images,
      );

      final refundOrder = RefundOrder.fromJson(response['data']);
      emit(OrdersRefunded(refundOrder: refundOrder));
    } on DioException catch (e) {
      emit(OrdersError(Errors.fromDioError(e)));
    } catch (e) {
      emit(OrdersError(Errors(message: e.toString())));
    }
  }

  Future<void> getAllReturns() async {
    emit(OrdersLoading());
    try {
      final response = await ordersServices.getAllReturns();
      emit(OrderReturnsLoaded(response));
    } on DioException catch (e) {
      emit(OrdersError(Errors.fromDioError(e)));
    } catch (e) {
      emit(OrdersError(Errors(message: e.toString())));
    }
  }
}

//
// 🔹 States
//
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersRefunded extends OrdersState {
  final RefundOrder refundOrder;

  OrdersRefunded({required this.refundOrder});
}

class OrdersLoaded extends OrdersState {
  final List<Order> orders;

  OrdersLoaded(this.orders);
}

class OrderDetailsLoaded extends OrdersState {
  final OrderDetailsModel orderDetails;

  OrderDetailsLoaded(this.orderDetails);
}

class OrderDetailsRefnudedLoaded extends OrdersState {
  final RefundedItem refundedItem;

  OrderDetailsRefnudedLoaded(this.refundedItem);
}

class OrderTrackLoaded extends OrdersState {
  final TrackOrder trackOrder;

  OrderTrackLoaded(this.trackOrder);
}

class OrderReturnsLoaded extends OrdersState {
  final List<AllReturns> allReturns;

  OrderReturnsLoaded(this.allReturns);
}

class OrdersError extends OrdersState {
  final Errors error;

  OrdersError(this.error);
}
