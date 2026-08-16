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
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      image: json['image'],
      imageUrl: json['image_url'],
      images: List<String>.from(json['images'] ?? []),
      isFavorite: json['is_favorite'] ?? false,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      ratingsCount: json['ratings_count'] ?? 0,
      finalPrice: double.tryParse(json['final_price'].toString()) ?? 0.0,
      discountType: json['discount_type'],
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
