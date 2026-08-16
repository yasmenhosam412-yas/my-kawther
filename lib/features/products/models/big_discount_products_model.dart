import 'package:elkawther/features/categories/models/category_products_model.dart';

double parseToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

class BigDiscountProductsModel {
  String? status;
  String? message;
  DiscountSection? topPercentDiscount;
  DiscountSection? topFixedDiscount;
  int? count;

  BigDiscountProductsModel({
    this.status,
    this.message,
    this.topPercentDiscount,
    this.topFixedDiscount,
    this.count,
  });

  factory BigDiscountProductsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return BigDiscountProductsModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      count: json['count'],
      topPercentDiscount:
          data?['top_percent_discount'] != null
              ? DiscountSection.fromJson(data['top_percent_discount'])
              : null,
      topFixedDiscount:
          data?['top_fixed_discount'] != null
              ? DiscountSection.fromJson(data['top_fixed_discount'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'count': count,
      'data': {
        'top_percent_discount': topPercentDiscount?.toJson(),
        'top_fixed_discount': topFixedDiscount?.toJson(),
      },
    };
  }

  /// ✅ copyWith
  BigDiscountProductsModel copyWith({
    String? status,
    String? message,
    DiscountSection? topPercentDiscount,
    DiscountSection? topFixedDiscount,
    int? count,
  }) {
    return BigDiscountProductsModel(
      status: status ?? this.status,
      message: message ?? this.message,
      topPercentDiscount: topPercentDiscount ?? this.topPercentDiscount,
      topFixedDiscount: topFixedDiscount ?? this.topFixedDiscount,
      count: count ?? this.count,
    );
  }
}

class DiscountSection {
  double? discountValue;
  List<BigDiscountData> products;

  DiscountSection({this.discountValue, required this.products});

  factory DiscountSection.fromJson(Map<String, dynamic> json) {
    double discount = parseToDouble(json['discount_value']);
    List<BigDiscountData> productList =
        (json['products'] as List<dynamic>?)
            ?.map(
              (item) =>
                  BigDiscountData.fromJson(item)..sectionDiscount = discount,
            )
            .toList() ??
        [];
    return DiscountSection(discountValue: discount, products: productList);
  }

  Map<String, dynamic> toJson() {
    return {
      'discount_value': discountValue,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }

  /// ✅ copyWith
  DiscountSection copyWith({
    double? discountValue,
    List<BigDiscountData>? products,
  }) {
    return DiscountSection(
      discountValue: discountValue ?? this.discountValue,
      products: products ?? this.products,
    );
  }
}

class BigDiscountData {
  int? id;
  String? name;
  String? description;
  String? image;
  List<String>? images;
  String? brand;
  String? category;
  String? priceBeforeDiscount;
  double? priceAfterDiscount;
  String? discountType;
  bool? isFavorite;
  double? rate;
  int? ratingsCount;
  double? averageRating;
  double? sectionDiscount;
  List<AvailableSize>? availableSizes;

  BigDiscountData({
    this.id,
    this.name,
    this.description,
    this.image,
    this.images,
    this.brand,
    this.category,
    this.priceBeforeDiscount,
    this.priceAfterDiscount,
    this.discountType,
    this.isFavorite,
    this.rate,
    this.ratingsCount,
    this.averageRating,
    this.sectionDiscount,
    this.availableSizes,
  });

  factory BigDiscountData.fromJson(
    Map<String, dynamic> json, {
    double? sectionDiscount,
  }) {
    return BigDiscountData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['main_image'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      brand: json['brand']?.toString(),
      category: json['category']?.toString(),
      priceBeforeDiscount: json['price_before_discount']?.toString(),
      priceAfterDiscount: parseToDouble(json['price_after_discount']),
      discountType: json['discount_type'],
      isFavorite: json['is_favorite'] ?? false,
      rate: parseToDouble(json['rate']),
      ratingsCount: json['ratings_count'] ?? 0,
      averageRating: parseToDouble(json['average_rating']),
      sectionDiscount: sectionDiscount,
      availableSizes:
          json['available_sizes'] != null
              ? (json['available_sizes'] as List)
                  .map((e) => AvailableSize.fromJson(e))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'main_image': image,
      'images': images,
      'brand': brand,
      'category': category,
      'price_before_discount': priceBeforeDiscount,
      'price_after_discount': priceAfterDiscount,
      'discount_type': discountType,
      'is_favorite': isFavorite,
      'rate': rate,
      'ratings_count': ratingsCount,
      'average_rating': averageRating,
      'section_discount': sectionDiscount,
      'available_sizes': availableSizes?.map((e) => e.toJson()).toList(),
    };
  }

  double get priceBeforeDiscountDouble => parseToDouble(priceBeforeDiscount);

  double get priceAfterDiscountDouble => priceAfterDiscount ?? 0.0;

  /// ✅ copyWith
  BigDiscountData copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    List<String>? images,
    String? brand,
    String? category,
    String? priceBeforeDiscount,
    double? priceAfterDiscount,
    String? discountType,
    bool? isFavorite,
    double? rate,
    int? ratingsCount,
    double? averageRating,
    double? sectionDiscount,
    List<AvailableSize>? availableSizes,
  }) {
    return BigDiscountData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      images: images ?? this.images,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      priceBeforeDiscount: priceBeforeDiscount ?? this.priceBeforeDiscount,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      discountType: discountType ?? this.discountType,
      isFavorite: isFavorite ?? this.isFavorite,
      rate: rate ?? this.rate,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      averageRating: averageRating ?? this.averageRating,
      sectionDiscount: sectionDiscount ?? this.sectionDiscount,
      availableSizes: availableSizes ?? this.availableSizes,
    );
  }
}
