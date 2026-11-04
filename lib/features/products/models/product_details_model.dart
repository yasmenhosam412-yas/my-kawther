import 'package:elkawther/features/categories/models/category_products_model.dart';

class ProductDetailsModel {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> images;
  final bool isFavorite;
  final double rate;
  final double averageRating;
  final int ratingsCount;
  final double finalPrice;
  final String discountType;
  final List<SizeModel> sizes;
  final List<AvailableSize> availableSizes;
  final Saleable? saleable;
  final Category? category;

  ProductDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.images,
    required this.isFavorite,
    required this.rate,
    required this.averageRating,
    required this.ratingsCount,
    required this.finalPrice,
    required this.discountType,
    required this.sizes,
    required this.availableSizes,
    required this.saleable,
    required this.category,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] ?? json;
    final data = rawData is Map<String, dynamic> ? rawData : json;

    return ProductDetailsModel(
      id: _asInt(data['id']),
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      imageUrl: data['image_url']?.toString() ?? '',
      images: (data['images'] as List<dynamic>?)
              ?.map((image) => image.toString())
              .toList() ??
          [],
      isFavorite: _asBool(data['is_favorite']),
      rate: _asDouble(data['rate']),
      averageRating: _asDouble(data['average_rating']),
      ratingsCount: _asInt(data['ratings_count']),
      finalPrice: double.tryParse(data['final_price']?.toString() ?? '0') ?? 0,
      discountType: data['discount_type']?.toString() ?? '',
      sizes:
          (data['sizes'] as List<dynamic>?)
              ?.map((e) => SizeModel.fromJson(e))
              .toList() ??
          [],
      availableSizes:
          (data['available_sizes'] as List<dynamic>?)
              ?.map((e) => AvailableSize.fromJson(e))
              .toList() ??
          [],
      saleable:
          data['saleable'] != null ? Saleable.fromJson(data['saleable']) : null,
      category:
          data['category'] != null ? Category.fromJson(data['category']) : null,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  return value?.toString().toLowerCase() == 'true' || value?.toString() == '1';
}

class Saleable {
  final int id;
  final double discountValue;
  final bool isActive;
  final String date;
  final String time;
  final String startsAt;
  final String endsAt;

  Saleable({
    required this.id,
    required this.discountValue,
    required this.isActive,
    required this.date,
    required this.time,
    required this.startsAt,
    required this.endsAt,
  });

  factory Saleable.fromJson(Map<String, dynamic> json) {
    return Saleable(
      id: _asInt(json['id']),
      discountValue:
          double.tryParse(json['discount_value']?.toString() ?? '0') ?? 0,
      isActive: _asBool(json['is_active']),
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      startsAt: json['starts_at']?.toString() ?? '',
      endsAt: json['ends_at']?.toString() ?? '',
    );
  }
}

class Category {
  final int id;
  final String name;
  final String imageUrl;

  Category({required this.id, required this.name, required this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }
}

// class ProductSize {
//   final int id;
//   final int productId;
//   final String size;
//   final double price;
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
//       price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
//       stock: json['stock'] ?? 0,
//     );
//   }
// }
