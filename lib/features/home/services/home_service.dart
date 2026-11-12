import 'package:dio/dio.dart';

import 'package:elkawther/core/constants/app_constants.dart';
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

  Future<List<Map<String, dynamic>>> getBannerProducts(String link) async {
    final uri = _resolveBannerApiUri(link);
    final response = await _dio.getUri(uri);
    final body = response.data;
    if (body is! Map<String, dynamic> || body['data'] == null) {
      throw const FormatException('Invalid banner API response');
    }

    final data = body['data'];
    final records = <Map<String, dynamic>>[];
    if (data is List) {
      records.addAll(_jsonRecords(data));
    } else if (data is Map<String, dynamic>) {
      for (final sectionName in [
        'top_percent_discount',
        'top_fixed_discount',
      ]) {
        final section = data[sectionName];
        if (section is Map<String, dynamic> && section['products'] is List) {
          records.addAll(
            _jsonRecords(section['products'] as List).map(
              (product) => {
                ...product,
                '_banner_discount_type':
                    sectionName == 'top_percent_discount' ? 'percent' : 'fixed',
                '_banner_discount_value': section['discount_value'],
              },
            ),
          );
        }
      }

      if (records.isEmpty && data['products'] is List) {
        records.addAll(_jsonRecords(data['products'] as List));
      }
    }

    return records
        .where(_hasProductPricing)
        .map((product) => _resolveProductImageUrls(product))
        .toList();
  }

  Uri _resolveBannerApiUri(String link) {
    final baseUri = Uri.parse(AppConstants.baseUrl);
    final parsed = Uri.tryParse(link.trim());
    if (parsed == null || parsed.host.isEmpty && parsed.path.isEmpty) {
      throw const FormatException('Invalid banner link');
    }

    var uri = parsed.hasScheme ? parsed : baseUri.resolveUri(parsed);
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw const FormatException('Unsupported banner link scheme');
    }

    if (uri.host == 'localhost' ||
        uri.host == '127.0.0.1' ||
        uri.host == '0.0.0.0' ||
        uri.host == baseUri.host) {
      uri = uri.replace(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.hasPort ? baseUri.port : null,
      );
    } else {
      throw const FormatException(
        'Banner link must use the configured API host',
      );
    }

    return uri;
  }

  List<Map<String, dynamic>> _jsonRecords(List values) =>
      values
          .whereType<Map>()
          .map((value) => Map<String, dynamic>.from(value))
          .toList();

  bool _hasProductPricing(Map<String, dynamic> product) {
    final sizes = product['available_sizes'];
    return product.containsKey('final_price') ||
        product.containsKey('price_after_discount') ||
        product.containsKey('price_before_discount') ||
        (sizes is List && sizes.isNotEmpty);
  }

  Map<String, dynamic> _resolveProductImageUrls(Map<String, dynamic> product) {
    final baseUri = Uri.parse(AppConstants.baseUrl);
    final resolved = Map<String, dynamic>.from(product);
    for (final key in ['image_url', 'main_image', 'image']) {
      final value = resolved[key];
      if (value is! String || value.trim().isEmpty) continue;

      final imageUri = Uri.tryParse(value);
      if (imageUri == null) continue;
      if (!imageUri.hasScheme) {
        resolved[key] = baseUri.resolveUri(imageUri).toString();
      } else if (imageUri.host == 'localhost' ||
          imageUri.host == '127.0.0.1' ||
          imageUri.host == '0.0.0.0' ||
          imageUri.host == baseUri.host) {
        resolved[key] =
            imageUri
                .replace(
                  scheme: baseUri.scheme,
                  host: baseUri.host,
                  port: baseUri.hasPort ? baseUri.port : null,
                )
                .toString();
      }
    }
    return resolved;
  }

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
    int limit = 10,
    int offset = 0,
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
      "/api/v1/user/products/search",
      queryParameters: {
        "limit": limit,
        "offset": offset,
        "sort": sort,
        "sortBy": sortBy,
        "search": search,
      },
    );
    final List dataList = response.data['data'] ?? const [];
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
