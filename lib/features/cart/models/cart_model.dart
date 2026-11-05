// product_model.dart

import 'package:elkawther/features/products/models/brand_products_model.dart';
import 'package:elkawther/features/categories/models/category_products_model.dart';

class ProductCart {
  final int id;
  final String name;
  final String description;
  final String image;
  final String imageUrl;
  final List<String> images;
  final bool isFavorite;
  final double averageRating;
  final int ratingsCount;
  final List<AvailableSize> availableSizes;
  final String finalPrice;
  final List<ProductSize> sizes;

  ProductCart({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.imageUrl,
    required this.images,
    required this.isFavorite,
    required this.averageRating,
    required this.ratingsCount,
    required this.availableSizes,
    required this.finalPrice,
    required this.sizes,
  });

  factory ProductCart.fromJson(Map<String, dynamic> json) {
    return ProductCart(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      imageUrl: json['image_url'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      isFavorite: json['is_favorite'] ?? false,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      ratingsCount: json['ratings_count'] ?? 0,
      availableSizes:
          (json['available_sizes'] as List<dynamic>?)
              ?.map((e) => AvailableSize.fromJson(e))
              .toList() ??
          [],
      finalPrice: json['final_price']?.toString() ?? '0.0',
      sizes:
          (json['sizes'] as List<dynamic>?)
              ?.map((e) => ProductSize.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// class ProductSize {
//   final int id;
//   final int productId;
//   final String size;
//   final String price;
//   final int stock;
//
//   ProductSize({
//     required this.id,
//     required this.productId,
//     required this.size,
//     required this.price,
//     required this.stock,
//   });
//
//   factory ProductSize.fromJson(Map<String, dynamic> json) {
//     return ProductSize(
//       id: json['id'] ?? 0,
//       productId: json['product_id'] ?? 0,
//       size: json['size'] ?? '',
//       price: json['price'] ?? '0.0',
//       stock: json['stock'] ?? 0,
//     );
//   }
// }
//

// cubon_model.dart

class Cubon {
  final bool success;
  final String message;
  final String code; // ✅ new field
  final double discount;
  final double totalAfterDiscount;
  final double originalTotal;

  /// Localized messages of promotions that were rejected for this cart
  /// (e.g. "spend 1,080 more to unlock free delivery"), shown as hints
  /// under the main coupon message. Empty when the coupon was applied.
  final List<String> hints;

  /// Complete user-facing message: the coupon rejection/error message
  /// plus any promotion hints on new lines.
  String get fullMessage =>
      hints.isEmpty ? message : '$message\n${hints.join('\n')}';

  const Cubon({
    required this.success,
    required this.message,
    required this.code,
    required this.discount,
    required this.totalAfterDiscount,
    required this.originalTotal,
    this.hints = const [],
  });

  factory Cubon.fromJson(Map<String, dynamic> json) {
    double asDouble(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    final hints = <String>[];
    final pricing = json['pricing'];
    if (pricing is Map<String, dynamic>) {
      final rejected = pricing['rejected_promotions'];
      if (rejected is List) {
        for (final promotion in rejected) {
          if (promotion is Map<String, dynamic>) {
            final text = '${promotion['message'] ?? ''}'.trim();
            if (text.isNotEmpty) hints.add(text);
          }
        }
      }
    }

    return Cubon(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      code: json['code'] ?? '',
      discount: asDouble(json['discount']),
      totalAfterDiscount: asDouble(json['total_after_discount']),
      originalTotal: asDouble(json['original_total']),
      hints: hints,
    );
  }
}

class CartModel {
  final int productId;
  final int id;
  final String name;
  final double originalPrice;
  final double discountedPrice;
  final int discountPercentage;
  final int quantity;
  final String mainImage;
  final double lineTotal;
  final String size;

  CartModel({
    required this.productId,
    required this.id,
    required this.name,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.quantity,
    required this.mainImage,
    required this.lineTotal,
    required this.size,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final product =
        json['product'] is Map<String, dynamic>
            ? json['product'] as Map<String, dynamic>
            : const <String, dynamic>{};
    final productSize =
        json['product_size'] is Map<String, dynamic>
            ? json['product_size'] as Map<String, dynamic>
            : json['size'] is Map<String, dynamic>
            ? json['size'] as Map<String, dynamic>
            : const <String, dynamic>{};
    final quantity = _parseCartInt(
      json['quantity'] ?? json['product_quantity'],
    );
    final discountedPrice = _parseCartDouble(
      json['discounted_price'] ?? json['price_at_time'],
    );
    final originalPrice = _parseCartDouble(
      json['original_price'] ?? productSize['original_price'],
    );
    final sizeId =
        json['product_size_id'] ??
        json['size_id'] ??
        (json['size'] is Map ? productSize['id'] : json['size']);

    return CartModel(
      productId: _parseCartInt(json['product_id'] ?? product['id']),
      id: _parseCartInt(json['id']),
      name: (json['name'] ?? product['name'] ?? '').toString(),
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      discountPercentage: _parseCartInt(json['discount_percentage']),
      quantity: quantity,
      mainImage:
          (json['main_image'] ??
                  json['image_url'] ??
                  product['image_url'] ??
                  product['image'] ??
                  '')
              .toString(),
      lineTotal: _parseCartDouble(
        json['line_total'] ?? json['total_price'],
        fallback: discountedPrice * quantity,
      ),
      size: sizeId?.toString() ?? '',
    );
  }

  CartModel copyWith({
    int? productId,
    int? id,
    String? name,
    double? originalPrice,
    double? discountedPrice,
    int? discountPercentage,
    int? quantity,
    String? mainImage,
    double? lineTotal,
    String? size,
  }) {
    return CartModel(
      productId: productId ?? this.productId,
      id: id ?? this.id,
      name: name ?? this.name,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      quantity: quantity ?? this.quantity,
      mainImage: mainImage ?? this.mainImage,
      lineTotal: lineTotal ?? this.lineTotal,
      size: size ?? this.size,
    );
  }
}

int _parseCartInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _parseCartDouble(dynamic value, {double fallback = 0}) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}

class CartItemData {
  final int id;
  final int userId;
  final int productId;
  final int productSizeId;
  final int productQuantity;
  final double priceAtTime;
  final double totalPrice;
  final double originalPrice;

  CartItemData({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productSizeId,
    required this.productQuantity,
    required this.priceAtTime,
    required this.totalPrice,
    required this.originalPrice,
  });

  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productSizeId: json['product_size_id'] ?? 0,
      productQuantity: int.tryParse(json['product_quantity'].toString()) ?? 0,
      priceAtTime: double.tryParse(json['price_at_time'].toString()) ?? 0.0,
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      originalPrice: double.tryParse(json['original_price'].toString()) ?? 0.0,
    );
  }
}

class ProductData {
  final int productId;
  final int productSizeId;
  final int productQuantity;
  final double discountedPrice;
  final double totalPrice;
  final double originalPrice;
  final String? name;
  final String? mainImage;
  final String? size;

  ProductData({
    required this.productId,
    required this.productSizeId,
    required this.productQuantity,
    required this.discountedPrice,
    required this.totalPrice,
    required this.originalPrice,
    this.name,
    this.mainImage,
    this.size,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return ProductData(
      productId: json['product_id'] != null ? json['product_id'] as int : 0,
      productSizeId:
          json['product_size_id'] != null ? json['product_size_id'] as int : 0,
      productQuantity:
          json['product_quantity'] != null
              ? int.tryParse(json['product_quantity'].toString()) ?? 0
              : 0,
      discountedPrice:
          json['price_at_time'] != null
              ? double.tryParse(json['price_at_time'].toString()) ?? 0.0
              : 0.0,
      totalPrice:
          json['total_price'] != null
              ? double.tryParse(json['total_price'].toString()) ?? 0.0
              : 0.0,
      originalPrice:
          json['original_price'] != null
              ? double.tryParse(json['original_price'].toString()) ?? 0.0
              : 0.0,
      name: product['name'] ?? '',
      mainImage: product['image_url'] ?? '',
      size: json['size']?['size']?.toString() ?? '',
    );
  }
}
