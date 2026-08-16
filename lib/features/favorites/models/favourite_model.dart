import 'package:elkawther/features/categories/models/category_products_model.dart';

class FavouriteModel {
  final String status;
  final String message;
  final List<FavouriteProductData> data;

  FavouriteModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json) {
    return FavouriteModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => FavouriteProductData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class FavouriteProductData {
  final int id;
  final String name;
  final String description;
  final String mainImageUrl;
  final List<String> images;
  final double finalPrice; // API sends as String or double
  final String? discountType; // can be null
  final String categoryName;
  final double rate;
  final double? averageRating;
  final int? ratingsCount;
  final int totalStock;
  final bool isFavorite;
  final List<SizeModel> sizes;
  final List<AvailableSizeFav> availableSize;
  final Saleable? saleable; // API can return null

  FavouriteProductData({
    required this.id,
    required this.name,
    required this.description,
    required this.mainImageUrl,
    required this.images,
    required this.finalPrice,
    required this.discountType,
    required this.categoryName,
    required this.rate,
    this.averageRating,
    this.ratingsCount,
    required this.totalStock,
    required this.isFavorite,
    required this.sizes,
    required this.availableSize,
    required this.saleable,
  });

  factory FavouriteProductData.fromJson(Map<String, dynamic> json) {
    return FavouriteProductData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      mainImageUrl: json['image_url'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      finalPrice: _parseToDouble(json['final_price']) ?? 0.0,
      discountType: json['discount_type']?.toString(),
      categoryName: json['category']?['name'] ?? '',
      rate: _parseToDouble(json['rate']) ?? 0.0,
      averageRating: _parseToDouble(json['average_rating']),
      ratingsCount:
          json['ratings_count'] != null
              ? int.tryParse(json['ratings_count'].toString())
              : null,
      totalStock: _calculateStock(json['available_sizes']),
      isFavorite: json['is_favorite'] ?? false,
      availableSize:
          (json['available_sizes'] as List?)
              ?.map((x) => AvailableSizeFav.fromJson(x))
              .toList() ??
          [],
      sizes:
          (json['sizes'] as List?)
              ?.map((x) => SizeModel.fromJson(x))
              .toList() ??
          [],
      saleable:
          json['saleable'] != null ? Saleable.fromJson(json['saleable']) : null,
    );
  }

  factory FavouriteProductData.placeholder(int id) {
    return FavouriteProductData(
      id: id,
      name: '',
      description: '',
      mainImageUrl: '',
      images: const [],
      finalPrice: 0,
      discountType: null,
      categoryName: '',
      rate: 0.0,
      averageRating: null,
      ratingsCount: null,
      totalStock: 0,
      isFavorite: true,
      sizes: [],
      availableSize: [],
      saleable: null,
    );
  }

  static int _calculateStock(dynamic availableSizes) {
    if (availableSizes is List) {
      return availableSizes.fold<int>(
        0,
        (sum, item) => sum + (int.tryParse(item['stock'].toString()) ?? 0),
      );
    }
    return 0;
  }

  static double? _parseToDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class AvailableSizeFav {
  int? id;
  String? size;
  double? originalPrice;
  double? price;
  int? stock;
  double? priceAfterDiscount;
  String? discountType;
  String? discountValue;

  AvailableSizeFav({
    this.id,
    this.size,
    this.originalPrice,
    this.price,
    this.stock,
    this.priceAfterDiscount,
    this.discountValue,
    this.discountType,
  });

  factory AvailableSizeFav.fromJson(Map<String, dynamic> json) {
    return AvailableSizeFav(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id']?.toString() ?? ''),
      size: json['size']?.toString(),
      price: FavouriteProductData._parseToDouble(json['price']),
      originalPrice: FavouriteProductData._parseToDouble(
        json['original_price'],
      ),
      priceAfterDiscount: FavouriteProductData._parseToDouble(
        json['price_after_discount'],
      ),
      stock:
          json['stock'] is int
              ? json['stock']
              : int.tryParse(json['stock']?.toString() ?? ''),
      discountType: json['discount_type']?.toString(),
      discountValue: json['discount_value'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
      'original_price': originalPrice,
      'price': price,
      'stock': stock,
    };
  }
}
