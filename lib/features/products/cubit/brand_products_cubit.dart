import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/products/models/brand_products_model.dart';
import 'package:elkawther/features/products/models/product_model.dart';
import 'package:elkawther/features/products/services/brand_products_service.dart';
import 'package:elkawther/core/utils/helper_functions.dart';

class BrandProductsCubit extends Cubit<BrandProductsState> {
  BrandProductsCubit(this._brandProductsService)
    : super(BrandProductsInitial());

  final BrandProductsService _brandProductsService;

  List<BrandProduct> brandProducts = [];
  List<ProductModel> searchResults = [];
  int _currentOffset = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get canLoadMore => _hasMore && !_isLoadingMore;

  Future<void> fetchBrandProducts(int brandId, BuildContext context) async {
    _currentOffset = 0;
    _hasMore = true;
    brandProducts = [];
    emit(BrandProductsLoading());

    try {
      final model = await _brandProductsService.getBrandProducts(
        brandId,
        limit: _limit,
        offset: _currentOffset,
      );
      brandProducts = model.products ?? [];
      _hasMore = brandProducts.length >= _limit;
      emit(BrandProductsLoaded(brandProducts: brandProducts));
    } on DioException catch (e) {
      if (!context.mounted) return;
      emit(
        BrandProductsError(message: HelperFunctions.handleDioError(e, context)),
      );
    } catch (_) {
      if (!context.mounted) return;
      emit(BrandProductsError(message: S.of(context).unexpectedError));
    }
  }

  Future<void> fetchBrandProductsMore(int brandId, BuildContext context) async {
    if (!_hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    _currentOffset = brandProducts.length;

    try {
      final model = await _brandProductsService.getBrandProducts(
        brandId,
        limit: _limit,
        offset: _currentOffset,
      );
      final fetched = model.products ?? [];
      brandProducts.addAll(
        fetched.where(
          (product) =>
              product.id == null ||
              !brandProducts.any((current) => current.id == product.id),
        ),
      );
      _hasMore = fetched.length >= _limit;
      emit(BrandProductsLoaded(brandProducts: brandProducts));
    } on DioException catch (e) {
      if (context.mounted) {
        emit(
          BrandProductsError(
            message: HelperFunctions.handleDioError(e, context),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        emit(BrandProductsError(message: S.of(context).unexpectedError));
      }
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> fetchBrandProductsBestSelling(
    int brandId,
    BuildContext context,
  ) async {
    emit(BrandProductsLoading());
    try {
      final model = await _brandProductsService.getBrandProductsBestSelling(
        brandId,
      );
      brandProducts = model.products ?? [];
      emit(BrandProductsLoaded(brandProducts: brandProducts));
    } on DioException catch (e) {
      if (!context.mounted) return;
      emit(
        BrandProductsError(message: HelperFunctions.handleDioError(e, context)),
      );
    } catch (_) {
      if (!context.mounted) return;
      emit(BrandProductsError(message: S.of(context).unexpectedError));
    }
  }

  Future<void> fetchBrandProductsNewArrival(
    int brandId,
    BuildContext context,
  ) async {
    emit(BrandProductsLoading());
    try {
      final model = await _brandProductsService.getBrandProductsNewArrival(
        brandId,
      );
      brandProducts = model.products ?? [];
      emit(BrandProductsLoaded(brandProducts: brandProducts));
    } on DioException catch (e) {
      if (!context.mounted) return;
      emit(
        BrandProductsError(message: HelperFunctions.handleDioError(e, context)),
      );
    } catch (_) {
      if (!context.mounted) return;
      emit(BrandProductsError(message: S.of(context).unexpectedError));
    }
  }

  Future<void> searchProducts(String query, BuildContext context) async {
    if (query.isEmpty) {
      searchResults = [];
      emit(SearchProductsLoaded(searchResults: searchResults));
      return;
    }

    emit(SearchProductsLoading());
    try {
      searchResults = await _brandProductsService.searchProduct(
        query,
        limit: _limit,
      );
      emit(SearchProductsLoaded(searchResults: searchResults));
    } on DioException catch (e) {
      if (!context.mounted) return;
      emit(
        BrandProductsError(message: HelperFunctions.handleDioError(e, context)),
      );
    } catch (_) {
      if (!context.mounted) return;
      emit(BrandProductsError(message: S.of(context).unexpectedError));
    }
  }
}

abstract class BrandProductsState extends Equatable {
  const BrandProductsState();

  @override
  List<Object> get props => [];
}

class BrandProductsInitial extends BrandProductsState {}

class BrandProductsLoading extends BrandProductsState {}

class BrandProductsLoaded extends BrandProductsState {
  final List<BrandProduct> brandProducts;

  const BrandProductsLoaded({required this.brandProducts});

  @override
  List<Object> get props => [brandProducts];
}

class BrandProductsError extends BrandProductsState {
  final String message;

  const BrandProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

class SearchProductsLoading extends BrandProductsState {}

class SearchProductsLoaded extends BrandProductsState {
  final List<ProductModel> searchResults;

  const SearchProductsLoaded({required this.searchResults});

  @override
  List<Object> get props => [searchResults];
}
