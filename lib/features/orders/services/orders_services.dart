import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elkawther/features/orders/models/all_returns.dart';
import 'package:elkawther/features/orders/models/orders_model.dart';
import 'package:elkawther/core/services/dio_service.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:elkawther/features/orders/models/track_order.dart';

class OrdersServices {
  final Dio _dio = DioService.dio;
  final SecureStorageHelper storageHelper = SecureStorageHelper();

  Future<OrdersModel> getGroupedOrders() async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/user/orders/grouped-by-status",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return OrdersModel.fromJson(response.data);
  }

  Future<OrderDetailsModel> getOrderDetails(int id) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/v1/user/order-details/$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return OrderDetailsModel.fromJson(response.data);
  }

  Future<RefundedItem> getOrderDetailsRefunded(int id) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/user/returns/$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return RefundedItem.fromJson(response.data);
  }

  Future<TrackOrder> getOrderTracking(int id) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/v1/user/track-order/$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return TrackOrder.fromJson(response.data);
  }

  Future<Map<String, dynamic>> refundRequest(
    int orderId,
    String reason,
    String? note,
    String refundAmount,
    String refundMethod,
    String address,
    List<File> images,
  ) async {
    final token = await storageHelper.safeRead('token');
    final formData = FormData.fromMap({
      'order_id': orderId,
      'reason': reason,
      'note': note ?? '',
      'refund_amount': refundAmount,
      'refund_method': refundMethod,
      'address': address,
      for (int i = 0; i < images.length; i++)
        'images[$i]': await MultipartFile.fromFile(images[i].path),
    });

    final response = await _dio.post(
      "/api/user/returns",
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return response.data;
  }

  Future<List<AllReturns>> getAllReturns() async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/user/returns",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final List<dynamic> rawData = response.data;
    return rawData.map((json) => AllReturns.fromJson(json)).toList();
  }

  Future<Review> addReviewRate(String id, int rate, String review) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.post(
      "/api/v1/user/products/$id/rate",
      data: {"rate": rate, "review": review},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return Review.fromJson(response.data['data']);
  }

  Future<List<ReviewData>> getProductReview(int id) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/v1/user/products/$id/reviews",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final List<dynamic> rawData = response.data['data'];
    return rawData.map((json) => ReviewData.fromJson(json)).toList();
  }
}

class Review {
  final int id;
  final int productId;
  final int userId;
  final int rate;
  final String review;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rate,
    required this.review,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'],
      rate: json['rate'],
      review: json['review'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'rate': rate,
      'review': review,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

//----------------------------------------------

class FetchReview {
  final List<ReviewData> data;

  FetchReview({required this.data});

  factory FetchReview.fromJson(Map<String, dynamic> json) {
    return FetchReview(
      data:
          (json['data'] as List)
              .map((item) => ReviewData.fromJson(item))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.map((review) => review.toJson()).toList()};
  }
}

class ReviewData {
  final int id;
  final int userId;
  final int rate;
  final String review;
  final DateTime createdAt;
  final User user;

  ReviewData({
    required this.id,
    required this.userId,
    required this.rate,
    required this.review,
    required this.createdAt,
    required this.user,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['id'],
      userId: json['user_id'],
      rate: json['rate'],
      review: json['review'],
      createdAt: DateTime.parse(json['created_at']),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'rate': rate,
      'review': review,
      'created_at': createdAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
