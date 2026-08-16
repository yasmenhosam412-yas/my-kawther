import 'package:dio/dio.dart';
import 'package:elkawther/features/categories/models/category_products_model.dart';
import 'package:elkawther/core/services/dio_service.dart';

class CategoryProductsService {
  final Dio _dio = DioService.dio;

  Future<CategoryProductsModel> getCategoryProducts(
    int categoryId, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    final response = await _dio.get(
      '/api/v1/user/categories/$categoryId/products',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
      },
    );
    return CategoryProductsModel.fromJson(response.data);
  }

  Future<CategoryProductsModelFilter> getCategoryProductsNewArrival(
    int categoryId, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    final response = await _dio.get(
      '/api/v1/user/categories/$categoryId/new-arrival-products',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
      },
    );
    return CategoryProductsModelFilter.fromJson(response.data);
  }

  Future<CategoryProductsModelFilter> getCategoryProductsBestSelling(
    int categoryId, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    final response = await _dio.get(
      '/api/v1/user/categories/$categoryId/best-selling-products',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
      },
    );
    return CategoryProductsModelFilter.fromJson(response.data);
  }

  Future<List<CategoryProductsData>> getSearchProducts(
    int categoryId,
    String query, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    final response = await _dio.get(
      '/api/v1/user/categories/$categoryId/products',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
        'search': query,
      },
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => CategoryProductsData.fromJson(json)).toList();
  }
}
