import 'package:dio/dio.dart';

import 'package:elkawther/features/home/models/banners_model.dart';
import 'package:elkawther/features/products/models/best_selling_products_model.dart';
import 'package:elkawther/features/products/models/big_discount_products_model.dart';
import 'package:elkawther/features/home/models/brands_model.dart';
import 'package:elkawther/features/categories/models/categories_model.dart';
import 'package:elkawther/features/home/models/health_issue_model.dart';
import 'package:elkawther/features/products/models/latest_products_model.dart';
import 'package:elkawther/features/products/models/product_model.dart';
import 'package:elkawther/features/products/models/special_packages_model.dart';
import 'package:elkawther/core/services/dio_service.dart';

class HomeService {
  final Dio _dio = DioService.dio;

  Future<BannersModel> getBanners() async {
    final response = await _dio.get("/api/v1/user/banners");
    return BannersModel.fromJson(response.data);
  }

  Future<CategoriesModel> getCategories({
    int? limit,
    int offset = 0,
    String sort = "ASC",
    String sortBy = "id",
  }) async {
    final queryParams = {"offset": offset, "sort": sort, "sortBy": sortBy};
    if (limit != null) queryParams["limit"] = limit;

    final response = await _dio.get(
      "/api/v1/user/categories",
      queryParameters: queryParams,
    );
    return CategoriesModel.fromJson(response.data);
  }

  Future<BrandsModel> getBrands({
    int limit = 25,
    int offset = 10,
    String sort = "ASC",
    String sortBy = "id",
  }) async {
    final response = await _dio.get(
      "/api/v1/user/brands",
      queryParameters: {
        "limit": limit,
        "offset": offset,
        "sort": sort,
        "sortBy": sortBy,
      },
    );
    return BrandsModel.fromJson(response.data);
  }

  Future<HealthIssueModel> getHealthIssueCategories({
    int limit = 10,
    int offset = 0,
    String sort = "ASC",
    String sortBy = "id",
  }) async {
    final response = await _dio.get(
      "/api/v1/user/health_issues",
      queryParameters: {
        "limit": limit,
        "offset": offset,
        "sort": sort,
        "sortBy": sortBy,
      },
    );
    return HealthIssueModel.fromJson(response.data);
  }

  Future<BestSellingProductsModel> getBestSellingProducts({
    int limit = 10,
    int offset = 0,
    String sort = "ASC",
    String sortBy = "id",
  }) async {
    final response = await _dio.get(
      "/api/v1/user/Best-selling-products",
      queryParameters: {
        "limit": limit,
        "offset": offset,
        "sort": sort,
        "sortBy": sortBy,
      },
    );
    return BestSellingProductsModel.fromJson(response.data);
  }

  Future<LatestProductsModel> getLatestProducts({
    int limit = 10,
    int offset = 0,
    String sort = "ASC",
    String sortBy = "id",
  }) async {
    final response = await _dio.get(
      "/api/v1/user/latest-products",
      queryParameters: {
        "limit": limit,
        "offset": offset,
        "sort": sort,
        "sortBy": sortBy,
      },
    );
    return LatestProductsModel.fromJson(response.data);
  }

  Future<SpecialPackagesModel> getSpecialPackages({
    int limit = 10,
    int offset = 0,
    String sort = "ASC",
    String sortBy = "id",
  }) async {
    final response = await _dio.get(
      "/api/v1/user/top-discount-products",
      queryParameters: {
        "limit": limit,
        "offset": offset,
        "sort": sort,
        "sortBy": sortBy,
      },
    );
    return SpecialPackagesModel.fromJson(response.data);
  }

  Future<BigDiscountProductsModel> getOnSale({
    int limit = 10,
    int offset = 0,
    String sort = "ASC",
    String sortBy = "id",
  }) async {
    final response = await _dio.get(
      "/api/v1/user/products/on/sale",
      queryParameters: {
        "limit": limit,
        "offset": offset,
        "sort": sort,
        "sortBy": sortBy,
      },
    );
    return BigDiscountProductsModel.fromJson(response.data);
  }

  Future<List<ProductModel>> getAllProducts({
    int limit = 10,
    int offset = 0,
    String sort = "ASC",
    String sortBy = "id",
  }) async {
    final response = await _dio.get(
      "/api/v1/user/products",
      queryParameters: {
        "limit": limit,
        "offset": offset,
        "sort": sort,
        "sortBy": sortBy,
      },
    );
    final List dataList = response.data['data'];
    return dataList.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<List<ProductModel>> getAllProductSearch({
    int limit = 10,
    int offset = 0,
    String sort = "ASC",
    String sortBy = "id",
    String search = "",
  }) async {
    final response = await _dio.get(
      "/api/v1/user/products/search?limit=10&offset=0&sort=ASC&sortBy=id&search$search",
    );
    final List dataList = response.data['data'];
    return dataList.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<List<ProductModel>> searchProduct(
    String query, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    final response = await _dio.get(
      '/api/v1/user/products/search',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
        'search': query,
      },
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
