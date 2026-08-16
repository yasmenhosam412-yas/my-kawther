import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/categories/models/category_products_model.dart';
import 'package:elkawther/features/categories/services/category_products_service.dart';
import 'package:elkawther/core/utils/helper_functions.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final CategoryProductsService _categoryProductsService;

  CategoryProductsCubit(this._categoryProductsService)
    : super(CategoryProductsInitial());

  List<CategoryProductsData> categoryProducts = [];

  Future<void> fetchCategoryProducts(
    int categoryId,
    BuildContext context, {
    int limit = 10,
    int offset = 0,
  }) async {
    emit(CategoryProductsLoading());
    try {
      final categoryProductsModel = await _categoryProductsService
          .getCategoryProducts(categoryId, limit: limit, offset: offset);

      categoryProducts = categoryProductsModel.data ?? [];

      final hasMore = (categoryProductsModel.data?.length ?? 0) >= limit;

      emit(
        CategoryProductsLoaded(
          categoryProducts: categoryProducts,
          isLoadMore: false,
          hasMore: hasMore,
        ),
      );
    } on DioException catch (dioError) {
      if (context.mounted) {
        final message = HelperFunctions.handleDioError(dioError, context);
        emit(CategoryProductsError(message: message));
      }
    } catch (error) {
      if (context.mounted) {
        emit(CategoryProductsError(message: S.of(context).unexpectedError));
      }
    }
  }

  Future<void> fetchMoreCategoryProducts(
    int categoryId,
    BuildContext context, {
    int limit = 10,
  }) async {
    if (state is CategoryProductsLoaded) {
      try {
        final currentState = state as CategoryProductsLoaded;
        if (!currentState.hasMore) return;

        final currentProducts = currentState.categoryProducts;

        final categoryProductsModel = await _categoryProductsService
            .getCategoryProducts(
              categoryId,
              limit: limit,
              offset: currentProducts.length,
            );

        final newProducts = categoryProductsModel.data ?? [];

        final updatedProducts = [
          ...currentProducts,
          ...newProducts.where(
            (p) => !currentProducts.any((c) => c.id == p.id),
          ),
        ];

        final hasMore = newProducts.length >= limit;

        emit(
          CategoryProductsLoaded(
            categoryProducts: updatedProducts,
            isLoadMore: true,
            hasMore: hasMore,
          ),
        );
      } on DioException catch (dioError) {
        if (context.mounted) {
          final message = HelperFunctions.handleDioError(dioError, context);
          emit(CategoryProductsError(message: message));
        }
      } catch (error) {
        if (context.mounted) {
          emit(CategoryProductsError(message: S.of(context).unexpectedError));
        }
      }
    }
  }

  Future<void> fetchCategoryProductsNewArrival(
    int categoryId,
    BuildContext context,
  ) async {
    emit(CategoryProductsLoading());
    try {
      final categoryProductsModel = await _categoryProductsService
          .getCategoryProductsNewArrival(categoryId);
      categoryProducts = categoryProductsModel.data ?? [];
      emit(CategoryProductsLoaded(categoryProducts: categoryProducts));
    } on DioException catch (dioError) {
      if (context.mounted) {
        final message = HelperFunctions.handleDioError(dioError, context);
        emit(CategoryProductsError(message: message));
      }
    } catch (error) {
      if (context.mounted) {
        emit(CategoryProductsError(message: S.of(context).unexpectedError));
      }
    }
  }

  Future<void> searchCategoryProductsPaginated(
    int categoryId,
    String query, {
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _categoryProductsService.getSearchProducts(
        categoryId,
        query,
        limit: limit,
        offset: offset,
      );

      if (state is CategoryProductsLoaded && offset > 0) {
        final currentState = state as CategoryProductsLoaded;
        final updatedProducts = [
          ...currentState.categoryProducts,
          ...response.where(
            (p) => !currentState.categoryProducts.any((c) => c.id == p.id),
          ),
        ];

        emit(
          CategoryProductsLoaded(
            categoryProducts: updatedProducts,
            isLoadMore: true,
            hasMore: response.length >= limit,
          ),
        );
      } else {
        emit(
          CategoryProductsLoaded(
            categoryProducts: response,
            isLoadMore: false,
            hasMore: response.length >= limit,
          ),
        );
      }
    } catch (e) {
      emit(CategoryProductsError(message: e.toString()));
    }
  }

  Future<void> fetchCategoryProductsBestSelling(
    int categoryId,
    BuildContext context,
  ) async {
    emit(CategoryProductsLoading());
    try {
      final categoryProductsModel = await _categoryProductsService
          .getCategoryProductsBestSelling(categoryId);
      categoryProducts = categoryProductsModel.data ?? [];
      emit(CategoryProductsLoaded(categoryProducts: categoryProducts));
    } on DioException catch (dioError) {
      if (context.mounted) {
        final message = HelperFunctions.handleDioError(dioError, context);
        emit(CategoryProductsError(message: message));
      }
    } catch (error) {
      if (context.mounted) {
        emit(CategoryProductsError(message: S.of(context).unexpectedError));
      }
    }
  }
}

abstract class CategoryProductsState extends Equatable {
  const CategoryProductsState();

  @override
  List<Object> get props => [];
}

class CategoryProductsInitial extends CategoryProductsState {}

class CategoryProductsLoading extends CategoryProductsState {}

class CategoryProductsLoaded extends CategoryProductsState {
  final List<CategoryProductsData> categoryProducts;
  final bool isLoadMore;
  final bool hasMore;

  const CategoryProductsLoaded({
    required this.categoryProducts,
    this.isLoadMore = false,
    this.hasMore = true,
  });

  @override
  List<Object> get props => [categoryProducts, isLoadMore, hasMore];
}

class CategoryProductsError extends CategoryProductsState {
  final String message;

  const CategoryProductsError({required this.message});

  @override
  List<Object> get props => [message];
}
