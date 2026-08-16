import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elkawther/features/cart/models/cart_model.dart';
import 'package:elkawther/features/orders/models/order_model.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/services/dio_service.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';

class CartServices {
  final Dio _dio = DioService.dio;
  final SecureStorageHelper storageHelper = SecureStorageHelper();

  Future<Either<Errors, CartItemData>> addItemToCart(
    int id,
    int quantity,
    int size,
  ) async {
    try {
      final token = await storageHelper.safeRead('token');

      if (token == null || token.isEmpty) {
        return const Left(Errors(message: "User not authenticated"));
      }

      final response = await _dio.post(
        "/api/v1/user/cart",
        data: {"product_id": id, "quantity": quantity, "product_size": size},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(CartItemData.fromJson(response.data['data']));
      } else if (response.data is Map<String, dynamic>) {
        return Left(Errors.fromJson(response.data));
      } else {
        return Left(
          Errors(
            message: response.data.toString(),
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioError catch (e) {
      return Left(Errors.fromDioError(e));
    } catch (e) {
      return Left(Errors(message: e.toString()));
    }
  }

  Future<void> removeItemFromCart(int id) async {
    final token = await storageHelper.safeRead('token');

    if (token == null) return;

    await _dio.delete(
      "/api/v1/user/cart/$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<List<CartModel>> getCart() async {
    final token = await storageHelper.safeRead('token');

    if (token == null) return [];

    final response = await _dio.get(
      "/api/v1/user/cart?limit=10&offset=0&sort=ASC&sortBy=id",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final List<dynamic> data = response.data['data'] ?? [];

    return data.map((item) => CartModel.fromJson(item)).toList();
  }

  Future<Cubon> applyCubon(String coupon) async {
    final token = await storageHelper.safeRead('token');

    if (token == null) {
      throw Exception("User not authenticated");
    }

    try {
      final response = await _dio.post(
        "/api/v1/user/cart/apply-coupon",
        data: FormData.fromMap({"coupon": coupon}),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (data["success"] == true) {
        return Cubon.fromJson(data);
      } else {
        final message = data["message"] ?? "Unknown error";
        throw Exception(message);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Either<Errors, ProductData>> updateQuantity(
    int id,
    String operation,
  ) async {
    final token = await storageHelper.safeRead('token');

    if (token == null) {
      return const Left(Errors(message: "User not authenticated"));
    }

    final response = await _dio.post(
      "/api/v1/user/cart/update-quantity",
      data: {"product_id": id, "operation": operation},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(ProductData.fromJson(response.data));
    } else {
      final errorMessage =
          response.data is Map
              ? (response.data['message']?.toString() ?? "Unknown error")
              : response.data.toString();

      return Left(Errors(message: errorMessage));
    }
  }

  Future<Either<Errors, OrderModel>> confirmOrder(
    int id,
    String method,
    String coupon,
    String notes, {
    File? image,
  }) async {
    try {
      final token = await storageHelper.safeRead('token');

      if (token == null) {
        return const Left(Errors(message: "User not authenticated"));
      }

      FormData formData = FormData.fromMap({
        "address_id": id,
        "payment_method": method,
        "coupon_code": coupon,
        "notes": notes,
        if (image != null)
          "payment_image": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split("/").last,
          ),
      });

      final response = await _dio.post(
        "/api/v1/user/orders",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(OrderModel.fromJson(response.data));
      } else if (response.statusCode == 422) {
        return const Left(
          Errors(
            message: "المدينة غير معروفة في دول مصاريف التوصيل",
            statusCode: 422,
          ),
        );
      } else {
        return Left(
          Errors(message: "Unexpected error", statusCode: response.statusCode),
        );
      }
    } on DioException catch (e) {
      return Left(Errors.fromDioError(e));
    } catch (e) {
      return Left(Errors(message: e.toString()));
    }
  }
}
