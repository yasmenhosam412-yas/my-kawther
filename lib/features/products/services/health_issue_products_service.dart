import 'package:dio/dio.dart';
import 'package:elkawther/features/products/models/health_issue_products_model.dart';
import 'package:elkawther/core/services/dio_service.dart';

class HealthIssueProductsService {
  final Dio _dio = DioService.dio;

  Future<HealthIssueProductsModel> getHealthIssueProducts(
    int issueId, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    final response = await _dio.get(
      '/api/v1/user/health_issues/$issueId/products',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
      },
    );
    return HealthIssueProductsModel.fromJson(response.data);
  }

  Future<HealthIssueProductsModel> getHealthProductsNewArrival(
    int healthissuesId, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    final response = await _dio.get(
      '/api/v1/user/healthissues/$healthissuesId/new-arrival-products',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
      },
    );
    return HealthIssueProductsModel.fromJson(response.data);
  }

  Future<HealthIssueProductsModel> getHealthProductsBestSelling(
    int healthissuesId, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    final response = await _dio.get(
      '/api/v1/user/healthissues/$healthissuesId/best-selling-products',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
      },
    );
    return HealthIssueProductsModel.fromJson(response.data);
  }
}
