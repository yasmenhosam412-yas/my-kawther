import 'package:dio/dio.dart';
import 'package:elkawther/features/products/models/product_model.dart';
import 'package:elkawther/features/products/models/brand_products_model.dart';
import 'package:elkawther/core/services/dio_service.dart';

class BrandProductsService {
  final Dio _dio = DioService.dio;

  Future<BrandProductsModel> getBrandProducts(
    int brandId, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    final response = await _dio.get(
      '/api/v1/user/brands/$brandId/products',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
      },
    );
    return BrandProductsModel.fromJson(response.data);
  }

  Future<BrandProductsModel> getBrandProductsBestSelling(
    int brandId, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    final response = await _dio.get(
      '/api/v1/user/brands/$brandId/best-selling-products',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
      },
    );
    return BrandProductsModel.fromJson(response.data);
  }

  Future<BrandProductsModel> getBrandProductsNewArrival(
    int brandId, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    final response = await _dio.get(
      '/api/v1/user/brands/$brandId/new-arrival-products',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
      },
    );
    return BrandProductsModel.fromJson(response.data);
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
