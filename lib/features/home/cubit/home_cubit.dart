import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/categories/models/categories_model.dart';
import 'package:elkawther/features/home/models/banners_model.dart';
import 'package:elkawther/features/home/models/brands_model.dart';
import 'package:elkawther/features/home/models/health_issue_model.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/home/services/home_service.dart';
import 'package:elkawther/features/products/models/best_selling_products_model.dart';
import 'package:elkawther/features/products/models/big_discount_products_model.dart';
import 'package:elkawther/features/products/models/latest_products_model.dart';
import 'package:elkawther/features/products/models/product_model.dart';
import 'package:elkawther/features/products/models/special_packages_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeService) : super(const HomeState());

  final HomeService _homeService;
  static const _categoriesPageSize = 5;
  static const _homeCategoriesPreviewSize = 10;
  static const _brandsPageSize = 10;
  static const _healthIssuesPageSize = 10;
  static const _searchPageSize = 10;
  static const _productsPageSize = 10;
  bool _isLoadingCategories = false;
  bool _isLoadingBrands = false;
  bool _isLoadingHealthIssues = false;
  bool _isLoadingProductList = false;
  bool _isLoadingSearchMore = false;
  int _searchGeneration = 0;
  String _activeSearchQuery = '';

  bool _hasMoreItems({
    required int fetchedCount,
    required int loadedCount,
    required int pageSize,
    int? totalCount,
  }) {
    if (totalCount != null) return loadedCount < totalCount;
    return fetchedCount >= pageSize;
  }

  Future<void> loadBanners({bool force = false}) async {
    if (!force && state.banners != null) return;
    try {
      final banners = await _homeService.getBanners();
      emit(state.copyWith(banners: banners));
    } catch (_) {
      // Banner failures should not block category browsing.
    }
  }

  Future<void> loadHomeData() async {
    if (state.status == HomeStatus.loading) return;

    emit(state.copyWith(status: HomeStatus.loading, clearError: true));

    try {
      final results = await Future.wait<Object>([
        _homeService.getBanners(),
        _homeService.getCategories(limit: _homeCategoriesPreviewSize),
        _homeService.getSpecialPackages(),
        _homeService.getBrands(limit: _brandsPageSize, offset: 0),
        _homeService.getHealthIssueCategories(
          limit: _healthIssuesPageSize,
          offset: 0,
        ),
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
      final brandItems = brands.data ?? const <BrandsData>[];
      final healthItems = healthIssues.data ?? const <HealthIssueData>[];

      emit(
        state.copyWith(
          status: HomeStatus.success,
          clearError: true,
          banners: banners,
          categories: categories,
          // Keep allCategories for paginated Categories screens (limit 5).
          // Don't seed it from the home preview list.
          clearCategoriesError: true,
          discounts: discounts,
          specialPackages: discounts,
          brandsModel: brands,
          brands: brandItems,
          brandsHasMore: _hasMoreItems(
            fetchedCount: brandItems.length,
            loadedCount: brandItems.length,
            pageSize: _brandsPageSize,
            totalCount: brands.count,
          ),
          healthIssues: healthIssues,
          healthIssuesHasMore: _hasMoreItems(
            fetchedCount: healthItems.length,
            loadedCount: healthItems.length,
            pageSize: _healthIssuesPageSize,
            totalCount: healthIssues.count,
          ),
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

  Future<void> loadCategories({
    bool loadMore = false,
    bool force = false,
  }) async {
    if (_isLoadingCategories) return;
    if (loadMore && (state.allCategories == null || !state.categoriesHasMore)) {
      return;
    }
    if (!loadMore && !force && state.allCategories != null) return;

    _isLoadingCategories = true;
    emit(
      state.copyWith(
        isLoadingCategoriesMore: true,
        clearCategoriesError: true,
        categoriesHasMore: loadMore ? state.categoriesHasMore : true,
      ),
    );

    final currentCategories =
        loadMore ? (state.allCategories?.data ?? const []) : const [];
    try {
      final response = await _homeService.getCategories(
        limit: _categoriesPageSize,
        offset: currentCategories.length,
      );
      final fetchedCategories = response.data;
      final List<CategoryData> combinedCategories =
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
            count: response.count ?? combinedCategories.length,
          ),
          isLoadingCategoriesMore: false,
          categoriesHasMore: _hasMoreItems(
            fetchedCount: fetchedCategories.length,
            loadedCount: combinedCategories.length,
            pageSize: _categoriesPageSize,
            totalCount: response.count,
          ),
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

  Future<void> loadBrands({bool loadMore = false, bool force = false}) async {
    if (_isLoadingBrands) return;
    if (loadMore && (!state.brandsHasMore || state.brands.isEmpty)) return;
    if (!loadMore && !force && state.brands.isNotEmpty) return;

    _isLoadingBrands = true;
    emit(
      state.copyWith(
        isLoadingBrandsMore: true,
        brandsHasMore: loadMore ? state.brandsHasMore : true,
      ),
    );

    final currentBrands = loadMore ? state.brands : const <BrandsData>[];
    try {
      final response = await _homeService.getBrands(
        limit: _brandsPageSize,
        offset: currentBrands.length,
      );
      final fetched = response.data ?? const <BrandsData>[];
      final combined =
          loadMore
              ? [
                ...currentBrands,
                ...fetched.where(
                  (brand) =>
                      brand.id == null ||
                      !currentBrands.any((current) => current.id == brand.id),
                ),
              ]
              : fetched;

      emit(
        state.copyWith(
          brandsModel: response,
          brands: combined,
          isLoadingBrandsMore: false,
          brandsHasMore: _hasMoreItems(
            fetchedCount: fetched.length,
            loadedCount: combined.length,
            pageSize: _brandsPageSize,
            totalCount: response.count,
          ),
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingBrandsMore: false));
    } finally {
      _isLoadingBrands = false;
    }
  }

  Future<void> loadHealthIssues({
    bool loadMore = false,
    bool force = false,
  }) async {
    if (_isLoadingHealthIssues) return;
    if (loadMore &&
        (!state.healthIssuesHasMore ||
            (state.healthIssues?.data?.isEmpty ?? true))) {
      return;
    }
    if (!loadMore && !force && state.healthIssues != null) return;

    _isLoadingHealthIssues = true;
    emit(
      state.copyWith(
        isLoadingHealthIssuesMore: true,
        healthIssuesHasMore: loadMore ? state.healthIssuesHasMore : true,
      ),
    );

    final currentIssues =
        loadMore
            ? (state.healthIssues?.data ?? const <HealthIssueData>[])
            : const <HealthIssueData>[];
    try {
      final response = await _homeService.getHealthIssueCategories(
        limit: _healthIssuesPageSize,
        offset: currentIssues.length,
      );
      final fetched = response.data ?? const <HealthIssueData>[];
      final combined =
          loadMore
              ? [
                ...currentIssues,
                ...fetched.where(
                  (issue) =>
                      issue.id == null ||
                      !currentIssues.any((current) => current.id == issue.id),
                ),
              ]
              : fetched;

      emit(
        state.copyWith(
          healthIssues: HealthIssueModel(
            status: response.status,
            message: response.message,
            data: combined,
            count: response.count ?? combined.length,
          ),
          isLoadingHealthIssuesMore: false,
          healthIssuesHasMore: _hasMoreItems(
            fetchedCount: fetched.length,
            loadedCount: combined.length,
            pageSize: _healthIssuesPageSize,
            totalCount: response.count,
          ),
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingHealthIssuesMore: false));
    } finally {
      _isLoadingHealthIssues = false;
    }
  }

  Future<void> loadViewMoreProducts(
    String productType, {
    bool loadMore = false,
  }) async {
    if (_isLoadingProductList) return;
    if (loadMore && !state.productsHasMore) return;

    _isLoadingProductList = true;
    emit(
      state.copyWith(
        isLoadingMore: true,
        productsHasMore: loadMore ? state.productsHasMore : true,
        status: loadMore ? state.status : HomeStatus.loading,
        clearError: !loadMore,
      ),
    );

    try {
      switch (productType) {
        case 'best_selling':
          final current =
              loadMore
                  ? (state.bestSelling?.data ??
                      const <BestSellingProductsData>[])
                  : const <BestSellingProductsData>[];
          final response = await _homeService.getBestSellingProducts(
            limit: _productsPageSize,
            offset: current.length,
          );
          final fetched =
              response.data ?? const <BestSellingProductsData>[];
          final combined = <BestSellingProductsData>[
            ...current,
            ...fetched.where(
              (item) =>
                  item.product?.id == null ||
                  !current.any(
                    (existing) => existing.product?.id == item.product?.id,
                  ),
            ),
          ];
          emit(
            state.copyWith(
              status: HomeStatus.success,
              bestSelling: BestSellingProductsModel(
                success: response.success,
                data: combined,
              ),
              isLoadingMore: false,
              productsHasMore: fetched.length >= _productsPageSize,
            ),
          );
          break;
        case 'new_arrival':
          final current =
              loadMore
                  ? (state.latestProducts?.data ??
                      const <LatestProductsData>[])
                  : const <LatestProductsData>[];
          final response = await _homeService.getLatestProducts(
            limit: _productsPageSize,
            offset: current.length,
          );
          final fetched = response.data ?? const <LatestProductsData>[];
          final combined = <LatestProductsData>[
            ...current,
            ...fetched.where(
              (item) =>
                  item.id == null ||
                  !current.any((existing) => existing.id == item.id),
            ),
          ];
          emit(
            state.copyWith(
              status: HomeStatus.success,
              latestProducts: LatestProductsModel(
                status: response.status,
                message: response.message,
                count: response.count,
                data: combined,
              ),
              isLoadingMore: false,
              productsHasMore: _hasMoreItems(
                fetchedCount: fetched.length,
                loadedCount: combined.length,
                pageSize: _productsPageSize,
                totalCount: response.count,
              ),
            ),
          );
          break;
        case 'big_discounts':
        case 'special_packages':
        case 'getAll':
          final current =
              loadMore ? state.packageProducts : const <SpecialPackagesData>[];
          final response = await _homeService.getSpecialPackages(
            limit: _productsPageSize,
            offset: current.length,
          );
          final section =
              productType == 'special_packages'
                  ? response.topFixedDiscount
                  : response.topPercentDiscount;
          final fetched = section?.products ?? const <SpecialPackagesData>[];
          final combined = [
            ...current,
            ...fetched.where(
              (item) =>
                  item.id == null ||
                  !current.any((existing) => existing.id == item.id),
            ),
          ];
          emit(
            state.copyWith(
              status: HomeStatus.success,
              specialPackages: response,
              packageProducts: combined,
              isLoadingMore: false,
              productsHasMore: fetched.length >= _productsPageSize,
            ),
          );
          break;
        case 'on/sale':
          final current =
              loadMore ? state.onSaleProducts : const <BigDiscountData>[];
          final response = await _homeService.getOnSale(
            limit: _productsPageSize,
            offset: current.length,
          );
          final fetched = <BigDiscountData>[
            ...(response.topPercentDiscount?.products ??
                const <BigDiscountData>[]),
            ...(response.topFixedDiscount?.products ??
                const <BigDiscountData>[]),
          ];
          final combined = <BigDiscountData>[
            ...current,
            ...fetched.where(
              (item) =>
                  item.id == null ||
                  !current.any((existing) => existing.id == item.id),
            ),
          ];
          emit(
            state.copyWith(
              status: HomeStatus.success,
              onSale: response,
              onSaleProducts: combined,
              isLoadingMore: false,
              productsHasMore: fetched.length >= _productsPageSize,
            ),
          );
          break;
        case 'all_prods':
          final current =
              loadMore ? state.allProducts : const <ProductModel>[];
          final fetched = await _homeService.getAllProducts(
            limit: _productsPageSize,
            offset: current.length,
          );
          final combined = [
            ...current,
            ...fetched.where(
              (item) =>
                  item.id == null ||
                  !current.any((existing) => existing.id == item.id),
            ),
          ];
          emit(
            state.copyWith(
              status: HomeStatus.success,
              allProducts: combined,
              isLoadingMore: false,
              productsHasMore: fetched.length >= _productsPageSize,
            ),
          );
          break;
        case 'categories':
          await loadCategories(loadMore: loadMore, force: !loadMore);
          emit(
            state.copyWith(
              status: HomeStatus.success,
              isLoadingMore: false,
              productsHasMore: state.categoriesHasMore,
            ),
          );
          break;
        case 'brands':
          await loadBrands(loadMore: loadMore, force: !loadMore);
          emit(
            state.copyWith(
              status: HomeStatus.success,
              isLoadingMore: false,
              productsHasMore: state.brandsHasMore,
            ),
          );
          break;
        case 'health_issues':
          await loadHealthIssues(loadMore: loadMore, force: !loadMore);
          emit(
            state.copyWith(
              status: HomeStatus.success,
              isLoadingMore: false,
              productsHasMore: state.healthIssuesHasMore,
            ),
          );
          break;
        default:
          emit(
            state.copyWith(
              status: HomeStatus.success,
              isLoadingMore: false,
              productsHasMore: false,
            ),
          );
      }
    } on DioException catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          isLoadingMore: false,
          error: Errors.fromDioError(error),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          isLoadingMore: false,
          error: Errors(message: error.toString()),
        ),
      );
    } finally {
      _isLoadingProductList = false;
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
