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

  Cubon({
    required this.success,
    required this.message,
    required this.code,
    required this.discount,
    required this.totalAfterDiscount,
    required this.originalTotal,
  });

  factory Cubon.fromJson(Map<String, dynamic> json) {
    return Cubon(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      code: json['code'] ?? '',
      discount: (json['discount'] ?? 0).toDouble(),
      totalAfterDiscount: (json['total_after_discount'] ?? 0).toDouble(),
      originalTotal: (json['original_total'] ?? 0).toDouble(),
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
    return CartModel(
      productId: json['product_id'],
      id: json['id'],
      name: json['name'],
      originalPrice: double.parse(json['original_price'].toString()),
      discountedPrice: double.parse(json['discounted_price'].toString()),
      discountPercentage: json['discount_percentage'],
      quantity: json['quantity'],
      mainImage: json['main_image'],
      lineTotal: double.parse(json['line_total'].toString()),
      size: json['size'].toString(),
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
