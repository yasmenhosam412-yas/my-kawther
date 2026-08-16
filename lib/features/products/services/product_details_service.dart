import 'package:dio/dio.dart';

import 'package:elkawther/features/products/models/related_product_model.dart';
import 'package:elkawther/features/products/models/product_details_model.dart';
import 'package:elkawther/core/services/dio_service.dart';

class ProductDetailsService {
  final Dio _dio = DioService.dio;

  Future<ProductDetailsModel> getProductDetails(int productId) async {
    final response = await _dio.get('/api/v1/user/show/$productId/product');
    return ProductDetailsModel.fromJson(response.data);
  }

  Future<List<RelatedProductDataModel>> getRelatedProducts(
    int productId,
  ) async {
    final response = await _dio.get('/api/v1/user/products/$productId/related');
    final List dataList = response.data['data'] as List;
    return dataList
        .map((data) => RelatedProductDataModel.fromJson(data))
        .toList();
  }
}
