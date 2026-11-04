import 'package:elkawther/features/categories/models/category_products_model.dart';

int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

bool? _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'true':
      case '1':
        return true;
      case 'false':
      case '0':
        return false;
    }
  }
  return null;
}

double parseToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

class SpecialPackagesModel {
  String? status;
  String? message;
  DiscountSection? topPercentDiscount;
  DiscountSection? topFixedDiscount;
  int? count;

  SpecialPackagesModel({
    this.status,
    this.message,
    this.topPercentDiscount,
    this.topFixedDiscount,
    this.count,
  });

  factory SpecialPackagesModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return SpecialPackagesModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      count: _parseInt(json['count']),
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
}

class DiscountSection {
  double? discountValue;
  List<SpecialPackagesData> products;
  int? total;

  DiscountSection({this.discountValue, required this.products, this.total});

  factory DiscountSection.fromJson(Map<String, dynamic> json) {
    double discount = parseToDouble(json['discount_value']);
    List<SpecialPackagesData> productList =
        (json['products'] as List<dynamic>?)
            ?.map(
              (item) =>
                  SpecialPackagesData.fromJson(item)
                    ..sectionDiscount = discount,
            )
            .toList() ??
        [];
    return DiscountSection(
      discountValue: discount,
      products: productList,
      total: _parseInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discount_value': discountValue,
      'products': products.map((e) => e.toJson()).toList(),
      'total': total,
    };
  }
}

class SpecialPackagesData {
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
  List<SizeModel>? sizes;
  List<AvailableSize>? availableSizes;

  SpecialPackagesData({
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
    this.sizes,
  });

  factory SpecialPackagesData.fromJson(Map<String, dynamic> json) {
    return SpecialPackagesData(
      id: _parseInt(json['id']),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      image: json['main_image']?.toString(),
      images:
          (json['images'] as List<dynamic>?)
              ?.map((image) => image.toString())
              .toList() ??
          [],
      brand: json['brand']?.toString(),
      category: json['category']?.toString(),
      priceBeforeDiscount: json['price_before_discount']?.toString(),
      priceAfterDiscount: parseToDouble(json['price_after_discount']),
      discountType: json['discount_type']?.toString(),
      isFavorite: _parseBool(json['is_favorite']) ?? false,
      rate: parseToDouble(json['rate']),
      ratingsCount: _parseInt(json['ratings_count']) ?? 0,
      averageRating: parseToDouble(json['average_rating']),
      availableSizes:
          (json['available_sizes'] as List<dynamic>?)
              ?.map((e) => AvailableSize.fromJson(e))
              .toList(),
      sizes:
          (json['sizes'] as List<dynamic>?)
              ?.map((e) => SizeModel.fromJson(e))
              .toList(),
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
      'sizes': sizes?.map((e) => e.toJson()).toList(),
    };
  }

  double get priceBeforeDiscountDouble => parseToDouble(priceBeforeDiscount);

  double get priceAfterDiscountDouble => priceAfterDiscount ?? 0.0;
}
