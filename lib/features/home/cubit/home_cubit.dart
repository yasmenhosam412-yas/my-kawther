import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/categories/models/categories_model.dart';
import 'package:elkawther/features/home/models/banners_model.dart';
import 'package:elkawther/features/home/models/brands_model.dart';
import 'package:elkawther/features/home/models/health_issue_model.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/home/services/home_service.dart';
import 'package:elkawther/features/products/models/best_selling_products_model.dart';
import 'package:elkawther/features/products/models/latest_products_model.dart';
import 'package:elkawther/features/products/models/product_model.dart';
import 'package:elkawther/features/products/models/special_packages_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeService) : super(const HomeState());

  final HomeService _homeService;
  static const _categoriesPageSize = 10;
  static const _searchPageSize = 10;
  bool _isLoadingCategories = false;
  bool _isLoadingSearchMore = false;
  int _searchGeneration = 0;
  String _activeSearchQuery = '';

  Future<void> loadHomeData() async {
    if (state.status == HomeStatus.loading) return;

    emit(state.copyWith(status: HomeStatus.loading, clearError: true));

    try {
      final results = await Future.wait<Object>([
        _homeService.getBanners(),
        _homeService.getCategories(limit: 10),
        _homeService.getSpecialPackages(),
        _homeService.getBrands(limit: 10, offset: 0),
        _homeService.getHealthIssueCategories(),
        _homeService.getBestSellingProducts(),
        _homeService.getLatestProducts(),
      ]);

      final banners = results[0] as BannersModel;
      final categories = results[1] as CategoriesModel;
      final discounts = results[2] as SpecialPackagesModel;
      final brands = results[3] as BrandsModel;
      final healthIssues = results[4] as HealthIssueModel;
      final bestSelling = results[5] as BestSellingProductsModel;
      final latestProducts = results[6] as LatestProductsModel;

      emit(
        state.copyWith(
          status: HomeStatus.success,
          clearError: true,
          banners: banners,
          categories: categories,
          allCategories: categories,
          categoriesHasMore: categories.data.length >= _categoriesPageSize,
          clearCategoriesError: true,
          discounts: discounts,
          specialPackages: discounts,
          brandsModel: brands,
          brands: brands.data ?? const [],
          healthIssues: healthIssues,
          bestSelling: bestSelling,
          latestProducts: latestProducts,
        ),
      );
    } on DioException catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          error: Errors.fromDioError(error),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          error: Errors(message: error.toString()),
        ),
      );
    }
  }

  Future<void> loadCategories({bool loadMore = false}) async {
    if (_isLoadingCategories) return;
    if (loadMore && (state.allCategories == null || !state.categoriesHasMore)) {
      return;
    }
    if (!loadMore && state.allCategories != null) return;

    _isLoadingCategories = true;
    emit(
      state.copyWith(isLoadingCategoriesMore: true, clearCategoriesError: true),
    );

    final currentCategories = state.allCategories?.data ?? const [];
    try {
      final response = await _homeService.getCategories(
        limit: _categoriesPageSize,
        offset: loadMore ? currentCategories.length : 0,
      );
      final fetchedCategories = response.data;
      final combinedCategories =
          loadMore
              ? [
                ...currentCategories,
                ...fetchedCategories.where(
                  (category) =>
                      !currentCategories.any(
                        (current) => current.id == category.id,
                      ),
                ),
              ]
              : fetchedCategories;

      emit(
        state.copyWith(
          allCategories: CategoriesModel(
            status: response.status,
            message: response.message,
            data: combinedCategories,
            count: response.count,
          ),
          isLoadingCategoriesMore: false,
          categoriesHasMore: fetchedCategories.length >= _categoriesPageSize,
          clearCategoriesError: true,
        ),
      );
    } on DioException catch (error) {
      emit(
        state.copyWith(
          isLoadingCategoriesMore: false,
          categoriesError: Errors.fromDioError(error),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoadingCategoriesMore: false,
          categoriesError: Errors(message: error.toString()),
        ),
      );
    } finally {
      _isLoadingCategories = false;
    }
  }

  Future<void> searchProducts(String query, {bool loadMore = false}) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      _searchGeneration++;
      _activeSearchQuery = '';
      _isLoadingSearchMore = false;
      emit(
        state.copyWith(
          searchResults: const [],
          isSearching: false,
          isLoadingSearchMore: false,
          searchHasMore: false,
          clearSearchError: true,
        ),
      );
      return;
    }

    late final int generation;
    final int offset;
    if (loadMore) {
      if (_isLoadingSearchMore ||
          normalizedQuery != _activeSearchQuery ||
          !state.searchHasMore ||
          state.isSearching) {
        return;
      }
      _isLoadingSearchMore = true;
      generation = _searchGeneration;
      offset = state.searchResults.length;
      emit(state.copyWith(isLoadingSearchMore: true, clearSearchError: true));
    } else {
      generation = ++_searchGeneration;
      _activeSearchQuery = normalizedQuery;
      _isLoadingSearchMore = false;
      offset = 0;
      emit(
        state.copyWith(
          searchResults: const [],
          isSearching: true,
          isLoadingSearchMore: false,
          searchHasMore: true,
          clearSearchError: true,
        ),
      );
    }

    try {
      final products = await _homeService.searchProduct(
        normalizedQuery,
        limit: _searchPageSize,
        offset: offset,
      );
      if (isClosed || generation != _searchGeneration) return;

      final currentProducts =
          loadMore ? state.searchResults : const <ProductModel>[];
      final mergedProducts = [
        ...currentProducts,
        ...products.where(
          (product) =>
              product.id == null ||
              !currentProducts.any((current) => current.id == product.id),
        ),
      ];
      emit(
        state.copyWith(
          searchResults: mergedProducts,
          isSearching: false,
          isLoadingSearchMore: false,
          searchHasMore: products.length >= _searchPageSize,
          clearSearchError: true,
        ),
      );
    } on DioException catch (error) {
      if (isClosed || generation != _searchGeneration) return;
      emit(
        state.copyWith(
          isSearching: false,
          isLoadingSearchMore: false,
          searchError: Errors.fromDioError(error).message,
        ),
      );
    } catch (error) {
      if (isClosed || generation != _searchGeneration) return;
      emit(
        state.copyWith(
          isSearching: false,
          isLoadingSearchMore: false,
          searchError: error.toString(),
        ),
      );
    } finally {
      if (loadMore && generation == _searchGeneration) {
        _isLoadingSearchMore = false;
      }
    }
  }
}
