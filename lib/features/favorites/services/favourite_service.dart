import 'package:dio/dio.dart';

import 'package:elkawther/core/services/dio_service.dart';
import 'package:elkawther/features/favorites/models/favourite_model.dart';

class FavouriteService {
  final Dio _dio = DioService.dio;

  Future<String> toggleFavourite(int productId) async {
    final response = await _dio.post('/api/v1/user/favorites/$productId');
    return response.data['message'];
  }

  Future<FavouriteModel?> getFavourites() async {
    final response = await _dio.get('/api/v1/user/favorites');
    if (response.data is Map && response.data['data'] != null) {
      return FavouriteModel.fromJson(response.data);
    }
    return null;
  }
}
