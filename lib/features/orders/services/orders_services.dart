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
      "/api/user/order-details/$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return OrderDetailsModel.fromJson(_resource(response.data));
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

    return RefundedItem.fromJson(_resource(response.data));
  }

  Future<TrackOrder> getOrderTracking(int id) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/user/track-order/$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return TrackOrder.fromJson(_resource(response.data));
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
    });
    for (final image in images.take(10)) {
      formData.files.add(
        MapEntry('images[]', await MultipartFile.fromFile(image.path)),
      );
    }

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

    final rawData = _asList(response.data);
    return rawData
        .whereType<Map>()
        .map((json) => AllReturns.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<String> cancelOrder(int id) async {
    final token = await storageHelper.safeRead('token');
    try {
      final response = await _dio.post(
        '/api/user/orders/$id/cancel',
        options: _authOptions(token),
      );
      final message = _message(response.data);
      if (_isFailureMessage(message)) {
        throw Exception(_failureText(message));
      }
      return message;
    } on DioException catch (e) {
      throw Exception(_failureText(_dioErrorMessage(e)));
    }
  }

  Future<Map<String, dynamic>> payOrder(int id) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.post(
      '/api/user/orders/$id/pay',
      options: _authOptions(token),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {'message': data?.toString() ?? ''};
  }

  Future<Map<String, dynamic>> orderPaymentStatus(int id) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      '/api/user/orders/$id/payment',
      options: _authOptions(token),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {'message': data?.toString() ?? ''};
  }

  Future<String> cancelReturn(int id) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.post(
      '/api/user/returns/$id/cancel',
      options: _authOptions(token),
    );
    return _message(response.data);
  }

  String paymentReceiptPath(int orderId) =>
      '/api/user/files/payment-receipt/$orderId';

  String returnImagePath(String image) {
    var name = image.trim();
    if (name.contains('%')) {
      name = Uri.decodeFull(name);
    }
    final slash = name.lastIndexOf('/');
    if (slash >= 0 && slash < name.length - 1) {
      name = name.substring(slash + 1);
    }
    return '/api/user/files/return-image/${Uri.encodeComponent(name)}';
  }

  Future<List<int>?> fetchReturnImage(String image) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      returnImagePath(image),
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'image/*',
        },
      ),
    );
    final data = response.data;
    if (data is List<int>) return data;
    if (data is List) return data.cast<int>();
    return null;
  }

  Options _authOptions(String? token) {
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }

  Map<String, dynamic> _resource(dynamic data) {
    if (data is! Map) return {};
    final map = Map<String, dynamic>.from(data);
    final nested = map['data'];
    if (nested is Map &&
        map['order_id'] == null &&
        (nested['order_id'] != null || nested['status'] != null)) {
      return Map<String, dynamic>.from(nested);
    }
    return map;
  }

  String _message(dynamic data) {
    if (data is Map && data['message'] != null) return data['message'].toString();
    return data?.toString() ?? '';
  }

  bool _isFailureMessage(String message) {
    return RegExp(r'^error\s*:', caseSensitive: false).hasMatch(message.trim());
  }

  String _failureText(String message) {
    final text = message.trim();
    final stripped = text.replaceFirst(
      RegExp(r'^error\s*:\s*', caseSensitive: false),
      '',
    ).trim();
    return stripped.isEmpty ? text : stripped;
  }

  String _dioErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map) {
      final message = data['message'] ?? data['error'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
      final errors = data['errors'];
      if (errors is Map) {
        final parts = <String>[];
        for (final value in errors.values) {
          if (value is List) {
            parts.addAll(value.map((item) => item.toString()));
          } else if (value != null) {
            parts.add(value.toString());
          }
        }
        if (parts.isNotEmpty) return parts.join('\n');
      }
    }
    if (data is String && data.trim().isNotEmpty) return data;
    final fallback = error.message?.trim();
    if (fallback != null && fallback.isNotEmpty) return fallback;
    return 'Unexpected error';
  }

  List<dynamic> _asList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    return const [];
  }

  Future<Review> addReviewRate(String id, int rate, String review) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.post(
      "/api/user/products/$id/rate",
      data: {"rate": rate, "review": review},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final body = response.data;
    final payload = body is Map
        ? (body['data'] is Map ? body['data'] : body)
        : null;
    if (payload is! Map) {
      return Review(
        id: 0,
        productId: int.tryParse(id) ?? 0,
        userId: 0,
        rate: rate,
        review: review,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    return Review.fromJson(Map<String, dynamic>.from(payload));
  }

  Future<List<ReviewData>> getProductReview(int id) async {
    final token = await storageHelper.safeRead('token');
    final response = await _dio.get(
      "/api/user/products/$id/reviews",
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
    int asInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    DateTime asDate(dynamic value) =>
        DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();

    return Review(
      id: asInt(json['id']),
      productId: asInt(json['product_id']),
      userId: asInt(json['user_id']),
      rate: asInt(json['rate']),
      review: json['review']?.toString() ?? '',
      createdAt: asDate(json['created_at']),
      updatedAt: asDate(json['updated_at']),
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
  final String? review;
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
      review: json['review']?.toString(),
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
