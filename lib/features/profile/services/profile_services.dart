import 'package:dio/dio.dart';
import 'package:elkawther/features/checkout/models/delivery_prices.dart';
import 'package:elkawther/features/profile/models/user_model.dart';

import 'package:elkawther/core/services/dio_service.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:elkawther/features/profile/models/points_response.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/models/setting_response.dart';

class ProfileServices {
  final Dio _dio = DioService.dio;
  final SecureStorageHelper storageHelper = SecureStorageHelper();

  Future<UserModel?> fetchUserData() async {
    final token = await storageHelper.safeRead('token');
    if (token == null || token.trim().isEmpty) return null;

    final response = await _dio.get('/api/user/user/data');

    final responseData = response.data;
    if (responseData is! Map) {
      throw const FormatException('Unexpected user profile response.');
    }

    dynamic userData =
        responseData['data'] ??
        responseData['user'] ??
        responseData['original'];
    if (userData is Map && userData['user'] is Map) {
      userData = userData['user'];
    }
    if (userData is! Map) {
      throw const FormatException('User profile data is missing.');
    }

    return UserModel.fromJson(Map<String, dynamic>.from(userData));
  }

  Future<List<AddressModel>> getAllAddresses(
    int limit,
    int offset,
    String sort,
    String sortBy,
  ) async {
    final token = await _requireAddressSession();
    final response = await _dio.get(
      "/api/user/addresses",
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'sortBy': sortBy,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return _parseAddressList(response.data);
  }

  Future<List<AddressModel>> addNewAddress({
    required String address,
    required String gov,
    required String city,
    required String street,
    required String landMark,
    required String type,
    required String apartment,
  }) async {
    final token = await _requireAddressSession();
    await _dio.post(
      "/api/user/addresses",
      data: {
        "address": address,
        "governorate": gov,
        "city": city,
        "street": street,
        "landmark": landMark,
        "type": type,
        "apartment": apartment,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return getAllAddresses(100, 0, "ASC", "id");
  }

  Future<List<AddressModel>> editAddress({
    String? address,
    String? gov,
    String? city,
    String? street,
    String? building,
    String? apartment,
    String? landMark,
    String? type,
    required int id,
  }) async {
    final token = await _requireAddressSession();
    await _dio.put(
      "/api/user/addresses/$id",
      data: {
        "address": address,
        "governorate": gov,
        "city": city,
        "street": street,
        "building": building,
        "apartment": apartment,
        "landmark": landMark,
        "type": type,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return getAllAddresses(100, 0, "ASC", "id");
  }

  Future<List<AddressModel>> toggleDefultAddress({required int id}) async {
    final token = await _requireAddressSession();
    await _dio.post(
      "/api/user/addresses/$id/toggle-default",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return getAllAddresses(100, 0, "ASC", "id");
  }

  Future<List<AddressModel>> deleteAddress({required int id}) async {
    final token = await _requireAddressSession();
    await _dio.delete(
      "/api/user/addresses/$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return getAllAddresses(100, 0, "ASC", "id");
  }

  Future<String> _requireAddressSession() async {
    final token = await storageHelper.safeRead('token');
    if (token == null || token.trim().isEmpty) {
      throw const FormatException('User is not authenticated.');
    }
    return token;
  }

  List<AddressModel> _parseAddressList(dynamic responseData) {
    dynamic data = responseData;
    if (data is Map) {
      data = data['data'] ?? data['addresses'];
      if (data is Map) {
        data = data['data'] ?? data['addresses'];
      }
    }
    if (data is! List) {
      throw const FormatException('Unexpected addresses response.');
    }
    return data
        .map((item) => AddressModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<UserModel> editData(
    int userId,
    String? email,
    String? name,
    String? phone,
  ) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.put(
      "/api/v1/user/update/$userId",
      data: {"email": email, "name": name, "phone": phone},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return UserModel.fromJson(response.data['data']);
  }

  Future<String> changePass(String? pass, String? confirmPass) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.post(
      "/api/v1/user/password/reset",
      data: {"password": pass, "password_confirmation": confirmPass},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.data is Map && response.data['message'] != null) {
      return response.data['message']; // Returns: "Password reset successful."
    } else {
      throw Exception("Unexpected response format");
    }
  }

  Future<String> contactUs(String name, String email, String message) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.post(
      "/api/v1/user/contact-messages",
      data: {"name": name, "email": email, "message": message},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.data is Map && response.data['message'] != null) {
      return response.data['message'];
    } else {
      throw Exception("Unexpected response format");
    }
  }

  Future<SettingsResponse> fetchSettings() async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/v1/user/settings",
      queryParameters: {
        'limit': 10,
        'offset': 0,
        'sort': 'ASC',
        'sortBy': 'id',
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.data is Map<String, dynamic>) {
      return SettingsResponse.fromJson(response.data);
    } else {
      throw Exception("Unexpected response format");
    }
  }

  Future<PointsResponse> getPointsHistory() async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/user/points",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return PointsResponse.fromJson(_pointsBody(response.data));
  }

  Future<PointsResponse> getPointsValid() async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/user/points/valid",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return PointsResponse.fromJson(_pointsBody(response.data));
  }

  Future<PointsResponse> getPointsNotValid() async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/user/points/notvalid",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return PointsResponse.fromJson(_pointsBody(response.data));
  }

  Future<PointsResponse> getPointsExpired() async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/user/points/expired",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return PointsResponse.fromJson(_pointsBody(response.data));
  }

  Map<String, dynamic> _pointsBody(dynamic data) {
    if (data is Map && data['data'] is Map) {
      return Map<String, dynamic>.from(data['data'] as Map);
    }
    if (data is Map && data['data'] is List) {
      return {
        'orders': data['data'],
        'valid_points_total': data['valid_points_total'] ?? data['total'],
        'consumed_points_total': data['consumed_points_total'],
        'expired_points_total': data['expired_points_total'],
      };
    }
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is List) return {'orders': data};
    return {};
  }

  Future<List<DeliveryPrice>> getDeliveryPricesAndCities() async {
    final response = await _dio.get(
      "/api/v1/user/delivary_prices",
      options: Options(headers: {'Accept': 'application/json'}),
    );

    final data = response.data;
    final raw = data is List
        ? data
        : data is Map && data['data'] is List
        ? data['data'] as List
        : const [];
    return raw
        .whereType<Map>()
        .map((json) => DeliveryPrice.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
}
