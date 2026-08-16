import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/categories/models/categories_model.dart';
import 'package:elkawther/features/home/models/banners_model.dart';
import 'package:elkawther/features/home/models/brands_model.dart';
import 'package:elkawther/features/home/models/health_issue_model.dart';
import 'package:elkawther/features/products/models/best_selling_products_model.dart';
import 'package:elkawther/features/products/models/big_discount_products_model.dart';
import 'package:elkawther/features/products/models/latest_products_model.dart';
import 'package:elkawther/features/products/models/product_model.dart';
import 'package:elkawther/features/products/models/special_packages_model.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.isLoadingMore = false,
    this.error,
    this.banners,
    this.categories,
    this.allCategories,
    this.discounts,
    this.brandsModel,
    this.brands = const [],
    this.healthIssues,
    this.bestSelling,
    this.latestProducts,
    this.specialPackages,
    this.packageProducts = const [],
    this.homeProducts = const [],
    this.onSale,
    this.onSaleProducts = const [],
    this.allProducts = const [],
    this.productsHasMore = true,
    this.searchResults = const [],
    this.searchHasMore = true,
    this.isSearching = false,
    this.isLoadingSearchMore = false,
    this.searchError,
  });

  final HomeStatus status;
  final bool isLoadingMore;
  final Errors? error;

  final BannersModel? banners;
  final CategoriesModel? categories;
  final CategoriesModel? allCategories;
  final SpecialPackagesModel? discounts;
  final BrandsModel? brandsModel;
  final List<BrandsData> brands;
  final HealthIssueModel? healthIssues;
  final BestSellingProductsModel? bestSelling;
  final LatestProductsModel? latestProducts;
  final SpecialPackagesModel? specialPackages;
  final List<SpecialPackagesData> packageProducts;
  final List<ProductModel> homeProducts;
  final BigDiscountProductsModel? onSale;
  final List<BigDiscountData> onSaleProducts;

  final List<ProductModel> allProducts;
  final bool productsHasMore;

  final List<ProductModel> searchResults;
  final bool searchHasMore;
  final bool isSearching;
  final bool isLoadingSearchMore;
  final String? searchError;

  bool get isHomeReady =>
      banners != null &&
      categories != null &&
      discounts != null &&
      brandsModel != null &&
      healthIssues != null &&
      bestSelling != null &&
      latestProducts != null &&
      specialPackages != null;

  HomeState copyWith({
    HomeStatus? status,
    bool? isLoadingMore,
    Errors? error,
    bool clearError = false,
    BannersModel? banners,
    CategoriesModel? categories,
    CategoriesModel? allCategories,
    SpecialPackagesModel? discounts,
    BrandsModel? brandsModel,
    List<BrandsData>? brands,
    HealthIssueModel? healthIssues,
    BestSellingProductsModel? bestSelling,
    LatestProductsModel? latestProducts,
    SpecialPackagesModel? specialPackages,
    List<SpecialPackagesData>? packageProducts,
    List<ProductModel>? homeProducts,
    BigDiscountProductsModel? onSale,
    List<BigDiscountData>? onSaleProducts,
    List<ProductModel>? allProducts,
    bool? productsHasMore,
    List<ProductModel>? searchResults,
    bool? searchHasMore,
    bool? isSearching,
    bool? isLoadingSearchMore,
    String? searchError,
    bool clearSearchError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : error ?? this.error,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      allCategories: allCategories ?? this.allCategories,
      discounts: discounts ?? this.discounts,
      brandsModel: brandsModel ?? this.brandsModel,
      brands: brands ?? this.brands,
      healthIssues: healthIssues ?? this.healthIssues,
      bestSelling: bestSelling ?? this.bestSelling,
      latestProducts: latestProducts ?? this.latestProducts,
      specialPackages: specialPackages ?? this.specialPackages,
      packageProducts: packageProducts ?? this.packageProducts,
      homeProducts: homeProducts ?? this.homeProducts,
      onSale: onSale ?? this.onSale,
      onSaleProducts: onSaleProducts ?? this.onSaleProducts,
      allProducts: allProducts ?? this.allProducts,
      productsHasMore: productsHasMore ?? this.productsHasMore,
      searchResults: searchResults ?? this.searchResults,
      searchHasMore: searchHasMore ?? this.searchHasMore,
      isSearching: isSearching ?? this.isSearching,
      isLoadingSearchMore: isLoadingSearchMore ?? this.isLoadingSearchMore,
      searchError: clearSearchError ? null : searchError ?? this.searchError,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isLoadingMore,
    error,
    banners,
    categories,
    allCategories,
    discounts,
    brandsModel,
    brands,
    healthIssues,
    bestSelling,
    latestProducts,
    specialPackages,
    packageProducts,
    homeProducts,
    onSale,
    onSaleProducts,
    allProducts,
    productsHasMore,
    searchResults,
    searchHasMore,
    isSearching,
    isLoadingSearchMore,
    searchError,
  ];
}
