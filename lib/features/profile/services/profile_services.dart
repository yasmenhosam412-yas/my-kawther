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

  Future<List<AddressModel>> getAllAddresses(
    int limit,
    int offset,
    String sort,
    String sortBy,
  ) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/v1/user/addresses?limit=$limit&offset=$offset&sort=$sort&sortBy=$sortBy",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final List<dynamic> rawData = response.data['data'];
    return rawData.map((json) => AddressModel.fromJson(json)).toList();
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
    final token = await storageHelper.safeRead('token');
    final response = await _dio.post(
      "/api/v1/user/addresses",
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

    final List<dynamic> rawData = response.data['data'];
    return rawData.map((json) => AddressModel.fromJson(json)).toList();
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
    final token = await storageHelper.safeRead('token');
    final response = await _dio.post(
      "/api/v1/user/addresses/$id",
      data: {
        "address": address,
        "governorate": gov,
        "city": city,
        "street": street,
        "building": building,
        "apartment": apartment,
        "landmark": landMark,
        "type": type,
        "_method": "PUT",
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final List<dynamic> data = response.data['data'];
    return data.map((json) => AddressModel.fromJson(json)).toList();
  }

  Future<AddNewAddress> toggleDefultAddress({required int id}) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.post(
      "/api/v1/user/addresses/$id/toggle-default",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return AddNewAddress.fromJson(response.data['data']);
  }

  Future<List<AddressModel>> deleteAddress({required int id}) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.delete(
      "/api/v1/user/addresses/$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final List<dynamic> rawData = response.data['data'];
    return rawData.map((json) => AddressModel.fromJson(json)).toList();
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

  Future<PointsResponse> getPointsValid() async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/v1/user/points/valid",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('orders')) {
      return PointsResponse.fromJson(data);
    } else {
      throw Exception("Unexpected response format");
    }
  }

  Future<PointsResponse> getPointsNotValid() async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/v1/user/points/notvalid",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('orders')) {
      return PointsResponse.fromJson(data);
    } else {
      throw Exception("Unexpected response format");
    }
  }

  Future<PointsResponse> getPointsExpired() async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/v1/user/points/expired",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('orders')) {
      return PointsResponse.fromJson(data);
    } else {
      throw Exception("Unexpected response format");
    }
  }

  Future<List<DeliveryPrice>> getDeliveryPricesAndCities() async {
    final response = await _dio.get(
      "/api/v1/user/delivary_prices",
      options: Options(headers: {'Accept': 'application/json'}),
    );

    final data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final List<dynamic> pricesJson = data['data'];
      return pricesJson
          .map((json) => DeliveryPrice.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Unexpected response format");
    }
  }
}
