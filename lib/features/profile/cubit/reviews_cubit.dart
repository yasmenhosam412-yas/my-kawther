import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/features/orders/services/orders_services.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {}

class ReviewError extends ReviewState {
  final Errors message;

  ReviewError(this.message);
}

class ReviewRatesLoaded extends ReviewState {
  final List<ReviewData> reviews;

  ReviewRatesLoaded(this.reviews);
}

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit(this.ordersServices) : super(ReviewInitial());

  final OrdersServices ordersServices;

  Future<void> leaveReview(String id, int rate, String review) async {
    emit(ReviewLoading());
    try {
      await ordersServices.addReviewRate(id, rate, review);
      emit(ReviewSuccess());
    } on DioException catch (e) {
      emit(ReviewError(Errors.fromDioError(e)));
    } catch (e) {
      emit(ReviewError(e is Errors ? e : Errors(message: e.toString())));
    }
  }

  Future<void> getReview(int id) async {
    emit(ReviewLoading());
    try {
      final response = await ordersServices.getProductReview(id);
      emit(ReviewRatesLoaded(response));
    } on DioException catch (e) {
      emit(ReviewError(Errors.fromDioError(e)));
    } catch (e) {
      emit(ReviewError(e is Errors ? e : Errors(message: e.toString())));
    }
  }
}
