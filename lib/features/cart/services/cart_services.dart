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
        "/api/user/cart",
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

    if (token == null || token.isEmpty) {
      throw const Errors(message: "User not authenticated");
    }

    await _dio.delete(
      "/api/user/cart/$id",
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

    if (token == null || token.isEmpty) return [];

    final response = await _dio.get(
      "/api/user/cart",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final responseData = response.data;
    final data =
        responseData is Map<String, dynamic>
            ? responseData['data']
            : responseData;
    if (data is! List) {
      throw const FormatException('Cart response data must be a list');
    }

    return data
        .map((item) => CartModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Cubon> applyCubon(String coupon) async {
    final token = await storageHelper.safeRead('token');

    if (token == null || token.isEmpty) {
      throw Exception("User not authenticated");
    }

    try {
      final response = await _dio.post(
        "/api/user/cart/apply-coupon",
        data: {"coupon": coupon},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final responseData = response.data;
      final data =
          responseData is Map<String, dynamic> &&
                  responseData['data'] is Map<String, dynamic>
              ? responseData['data'] as Map<String, dynamic>
              : responseData as Map<String, dynamic>;

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

    if (token == null || token.isEmpty) {
      return const Left(Errors(message: "User not authenticated"));
    }

    final response = await _dio.post(
      "/api/user/cart/update-quantity",
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
      final responseData = response.data;
      final data =
          responseData is Map<String, dynamic> &&
                  responseData['data'] is Map<String, dynamic>
              ? responseData['data'] as Map<String, dynamic>
              : responseData as Map<String, dynamic>;
      return Right(ProductData.fromJson(data));
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

      if (token == null || token.isEmpty) {
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
        "/api/user/orders",
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
        final responseData = response.data;
        final orderData =
            responseData is Map<String, dynamic> &&
                    responseData['data'] is Map<String, dynamic>
                ? responseData['data'] as Map<String, dynamic>
                : responseData as Map<String, dynamic>;
        return Right(OrderModel.fromJson(orderData));
      } else {
        final message =
            response.data is Map
                ? (response.data['message']?.toString() ??
                    'Could not place the order')
                : 'Could not place the order';
        return Left(Errors(message: message, statusCode: response.statusCode));
      }
    } on DioException catch (e) {
      return Left(Errors.fromDioError(e));
    } catch (e) {
      return Left(Errors(message: e.toString()));
    }
  }
}
