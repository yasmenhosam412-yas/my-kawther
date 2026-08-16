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
    final data = json['data'] ?? json;

    return ProductDetailsModel(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['image_url'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      isFavorite: data['is_favorite'] ?? false,
      rate: (data['rate'] ?? 0).toDouble(),
      averageRating: double.tryParse(data['average_rating'].toString()) ?? 0,
      ratingsCount: data['ratings_count'] ?? 0,
      finalPrice: double.tryParse(data['final_price']?.toString() ?? '0') ?? 0,
      discountType: data['discount_type'] ?? '',
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
      id: json['id'],
      discountValue:
          double.tryParse(json['discount_value']?.toString() ?? '0') ?? 0,
      isActive: json['is_active'] == 1,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      startsAt: json['starts_at'] ?? '',
      endsAt: json['ends_at'] ?? '',
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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
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
