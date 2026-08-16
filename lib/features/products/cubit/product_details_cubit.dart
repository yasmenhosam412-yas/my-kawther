import 'package:elkawther/core/errors/errors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:elkawther/features/products/models/related_product_model.dart';
import 'package:elkawther/features/products/models/product_details_model.dart';
import 'package:elkawther/features/products/services/product_details_service.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this._service) : super(ProductDetailsInitial());

  final ProductDetailsService _service;

  Future<void> fetchProductDetails(int productId, BuildContext context) async {
    emit(ProductDetailsLoading());
    try {
      final product = await _service.getProductDetails(productId);
      emit(ProductDetailsLoaded(product));
    } on DioException catch (e) {
      emit(ProductDetailsError(Errors.fromDioError(e)));
    } catch (e) {
      emit(ProductDetailsError(Errors(message: e.toString())));
    }
  }

  Future<void> fetchRelatedProducts(int productId, BuildContext context) async {
    emit(RelatedProductsLoading());
    try {
      final related = await _service.getRelatedProducts(productId);
      emit(RelatedProductsLoaded(related));
    } on DioException catch (e) {
      emit(RelatedProductsError(Errors.fromDioError(e).message));
    } catch (e) {
      emit(RelatedProductsError(e.toString()));
    }
  }
}

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetailsModel product;
  ProductDetailsLoaded(this.product);
}

class ProductDetailsError extends ProductDetailsState {
  final Errors message;
  ProductDetailsError(this.message);
}

class RelatedProductsLoading extends ProductDetailsState {}

class RelatedProductsLoaded extends ProductDetailsState {
  final List<RelatedProductDataModel> relatedProducts;
  RelatedProductsLoaded(this.relatedProducts);
}

class RelatedProductsError extends ProductDetailsState {
  final String message;
  RelatedProductsError(this.message);
}
