import 'package:dio/dio.dart';

import 'package:elkawther/core/services/dio_service.dart';
import 'package:elkawther/features/favorites/models/favourite_model.dart';

class FavouriteService {
  final Dio _dio = DioService.dio;

  Future<String> toggleFavourite(int productId) async {
    final response = await _dio.post('/api/user/favorites/$productId');
    final data = response.data;
    if (data is Map && data['message'] != null) return data['message'].toString();
    return '';
  }

  Future<FavouriteModel?> getFavourites() async {
    final response = await _dio.get('/api/user/favorites');
    final data = response.data;
    if (data is List) {
      return FavouriteModel(status: '', message: '', data: _products(data));
    }
    if (data is! Map) return null;
    final map = Map<String, dynamic>.from(data);
    final raw = map['data'] ?? map['favorites'] ?? map['products'];
    if (raw is List) {
      return FavouriteModel(
        status: '${map['status'] ?? ''}',
        message: '${map['message'] ?? ''}',
        data: _products(raw),
      );
    }
    if (raw is Map && raw['data'] is List) {
      return FavouriteModel(
        status: '${map['status'] ?? ''}',
        message: '${map['message'] ?? ''}',
        data: _products(raw['data'] as List),
      );
    }
    return FavouriteModel(status: '', message: '', data: const []);
  }

  List<FavouriteProductData> _products(List<dynamic> raw) {
    return raw.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);
      final nested = map['product'];
      if (nested is Map) {
        final product = Map<String, dynamic>.from(nested);
        product['id'] ??= map['product_id'] ?? map['id'];
        return FavouriteProductData.fromJson(product);
      }
      map['id'] ??= map['product_id'];
      return FavouriteProductData.fromJson(map);
    }).toList();
  }
}
