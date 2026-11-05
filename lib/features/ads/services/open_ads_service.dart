import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:elkawther/core/constants/app_constants.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/services/dio_service.dart';
import 'package:elkawther/features/ads/models/ads_model.dart';
import 'package:flutter/foundation.dart';

class OpenAdsService {
  final Dio _dio = DioService.dio;

  Future<Either<Errors, List<AdsModel>>> getOpeningAds() async {
    final cancelToken = CancelToken();
    try {
      final response = await _dio
          .get(
            '/api/v1/user/openingAd',
            queryParameters: {'device': _deviceName},
            cancelToken: cancelToken,
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              cancelToken.cancel('Opening ad request timed out');
              throw TimeoutException('Opening ad request timed out');
            },
          );
      final body = response.data;
      if (body is! Map || body['data'] is! List) {
        throw const FormatException('Invalid opening ads response');
      }

      final baseUri = Uri.parse(AppConstants.baseUrl);
      final device = _deviceName;
      final adsList =
          (body['data'] as List)
              .whereType<Map>()
              .map((item) => AdsModel.fromJson(Map<String, dynamic>.from(item)))
              .where(
                (ad) =>
                    ad.isActive && ad.isScheduled && ad.matchesDevice(device),
              )
              .map(
                (ad) => AdsModel(
                  id: ad.id,
                  imageUrl: _resolveImageUrl(ad.imageUrl, baseUri),
                  isActive: ad.isActive,
                  title: ad.title,
                  content: ad.content,
                  link: ad.link,
                  displayFrequency: ad.displayFrequency,
                  priority: ad.priority,
                  startsAt: ad.startsAt,
                  endsAt: ad.endsAt,
                  device: ad.device,
                ),
              )
              .toList()
            ..sort((a, b) => b.priority.compareTo(a.priority));

      return Right(adsList);
    } on DioException catch (e) {
      return Left(Errors.fromDioError(e));
    } on TimeoutException {
      return const Left(Errors(message: 'Opening ad request timed out'));
    } on FormatException catch (e) {
      return Left(Errors(message: e.message));
    }
  }

  String get _deviceName {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      default:
        return 'web';
    }
  }

  String? _resolveImageUrl(String? imageUrl, Uri baseUri) {
    if (imageUrl == null) return null;
    final uri = Uri.tryParse(imageUrl);
    if (uri == null) return null;

    if (uri.hasScheme) {
      if (uri.host == 'localhost' ||
          uri.host == '127.0.0.1' ||
          uri.host == '0.0.0.0') {
        return uri
            .replace(
              scheme: baseUri.scheme,
              host: baseUri.host,
              port: baseUri.hasPort ? baseUri.port : null,
            )
            .toString();
      }
      return uri.toString();
    }

    final path =
        uri.path.startsWith('/') ? uri : uri.replace(path: '/${uri.path}');
    return baseUri.resolveUri(path).toString();
  }
}
