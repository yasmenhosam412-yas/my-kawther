import 'package:elkawther/features/categories/models/category_products_model.dart';

class RelatedProductDataModel {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final String? imageUrl;
  final List<String> images;
  final bool isFavorite;
  final double averageRating;
  final int ratingsCount;
  final double finalPrice;
  final String? discountType;
  final List<AvailableSize> availableSizes;
  final List<SizeModel> sizes;
  final Saleable? saleable; // nullable

  RelatedProductDataModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.imageUrl,
    required this.images,
    required this.isFavorite,
    required this.averageRating,
    required this.ratingsCount,
    required this.finalPrice,
    this.discountType,
    required this.availableSizes,
    required this.sizes,
    this.saleable,
  });

  factory RelatedProductDataModel.fromJson(Map<String, dynamic> json) {
    return RelatedProductDataModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      imageUrl: json['image_url']?.toString(),
      images: (json['images'] as List<dynamic>?)
              ?.map((image) => image.toString())
              .toList() ??
          [],
      isFavorite: _asBool(json['is_favorite']),
      averageRating: _asDouble(json['average_rating']),
      ratingsCount: _asInt(json['ratings_count']),
      finalPrice: _asDouble(json['final_price']),
      discountType: json['discount_type']?.toString(),
      availableSizes:
          (json['available_sizes'] as List<dynamic>?)
              ?.map((e) => AvailableSize.fromJson(e))
              .toList() ??
          [],
      sizes:
          (json['sizes'] as List<dynamic>?)
              ?.map((e) => SizeModel.fromJson(e))
              .toList() ??
          [],
      saleable:
          json['saleable'] != null ? Saleable.fromJson(json['saleable']) : null,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
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
