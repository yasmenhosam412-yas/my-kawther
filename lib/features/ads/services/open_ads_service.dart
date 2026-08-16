import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/services/dio_service.dart';
import 'package:elkawther/features/ads/models/ads_model.dart';

class OpenAdsService {
  final Dio _dio = DioService.dio;

  Future<Either<Errors, List<AdsModel>>> getOpeningAds() async {
    try {
      final response = await _dio.get("/api/v1/user/openingAd");
      final List<dynamic> adsJson = response.data['data'];

      final adsList = adsJson.map((json) => AdsModel.fromJson(json)).toList();

      return Right(adsList);
    } on DioException catch (e) {
      return Left(Errors.fromDioError(e));
    }
  }
}
