import 'package:elkawther/features/categories/models/category_products_model.dart';

class BestSellingProductsModel {
  bool? success;
  List<BestSellingProductsData>? data;

  BestSellingProductsModel({this.success, this.data});

  factory BestSellingProductsModel.fromJson(Map<String, dynamic> json) {
    return BestSellingProductsModel(
      success: json['success'] as bool?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => BestSellingProductsData.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class BestSellingProductsData {
  String? totalSold;
  ProductData? product;

  BestSellingProductsData({this.totalSold, this.product});

  factory BestSellingProductsData.fromJson(Map<String, dynamic> json) {
    return BestSellingProductsData(
      totalSold: json['total_sold']?.toString(),
      product:
          json['product'] != null
              ? ProductData.fromJson(json['product'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'total_sold': totalSold,
    'product': product?.toJson(),
  };
}

class ProductData {
  int? id;
  String? name;
  String? description;
  double? rate;
  String? image;
  String? imageUrl;
  int? brandId;
  int? categoryId;
  String? saleableType;
  int? saleableId;
  String? createdAt;
  String? updatedAt;
  double? finalPrice;
  String? discountType;
  bool? isFavorite;
  double? averageRating;
  int? ratingsCount;
  List<AvailableSize>? availableSizes;
  List<SizeModel>? sizes;
  Saleable? saleable;

  ProductData({
    this.id,
    this.name,
    this.description,
    this.rate,
    this.image,
    this.imageUrl,
    this.brandId,
    this.categoryId,
    this.saleableType,
    this.saleableId,
    this.createdAt,
    this.updatedAt,
    this.finalPrice,
    this.discountType,
    this.isFavorite,
    this.averageRating,
    this.ratingsCount,
    this.availableSizes,
    this.sizes,
    this.saleable,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
    id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
    name: json['name']?.toString(),
    description: json['description']?.toString(),
    rate: json['rate'] != null ? double.tryParse('${json['rate']}') : null,
    image: json['image']?.toString(),
    imageUrl: json['image_url']?.toString(),
    brandId:
        json['brand_id'] is int
            ? json['brand_id']
            : int.tryParse('${json['brand_id']}'),
    categoryId:
        json['category_id'] is int
            ? json['category_id']
            : int.tryParse('${json['category_id']}'),
    saleableType: json['saleable_type']?.toString(),
    saleableId:
        json['saleable_id'] is int
            ? json['saleable_id']
            : int.tryParse('${json['saleable_id']}'),
    createdAt: json['created_at']?.toString(),
    updatedAt: json['updated_at']?.toString(),
    finalPrice:
        json['final_price'] != null
            ? double.tryParse('${json['final_price']}')
            : null,
    discountType: json['discount_type']?.toString(),
    isFavorite:
        json['is_favorite'] is bool
            ? json['is_favorite']
            : (json['is_favorite'] == 1),
    averageRating:
        json['average_rating'] != null
            ? double.tryParse('${json['average_rating']}')
            : null,
    ratingsCount:
        json['ratings_count'] != null
            ? int.tryParse('${json['ratings_count']}') ?? 0
            : 0,
    availableSizes:
        (json['available_sizes'] as List<dynamic>?)
            ?.map((e) => AvailableSize.fromJson(e))
            .toList(),
    sizes:
        (json['sizes'] as List<dynamic>?)
            ?.map((e) => SizeModel.fromJson(e))
            .toList(),
    saleable:
        json['saleable'] != null ? Saleable.fromJson(json['saleable']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'rate': rate,
    'image': image,
    'image_url': imageUrl,
    'brand_id': brandId,
    'category_id': categoryId,
    'saleable_type': saleableType,
    'saleable_id': saleableId,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'final_price': finalPrice,
    'discount_type': discountType,
    'is_favorite': isFavorite,
    'average_rating': averageRating,
    'ratings_count': ratingsCount,
    'available_sizes': availableSizes?.map((e) => e.toJson()).toList(),
    'sizes': sizes?.map((e) => e.toJson()).toList(),
    'saleable': saleable?.toJson(),
  };
}

class Saleable {
  int? id;
  String? title;
  String? discountValue;
  String? startDate;
  String? endDate;
  String? expireDate;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Saleable({
    this.id,
    this.title,
    this.discountValue,
    this.startDate,
    this.endDate,
    this.expireDate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Saleable.fromJson(Map<String, dynamic> json) {
    return Saleable(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      title: json['title']?.toString(),
      discountValue: json['discount_value']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      expireDate: json['expire_date']?.toString(),
      isActive:
          json['is_active'] is int
              ? json['is_active']
              : int.tryParse('${json['is_active']}'),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'discount_value': discountValue,
      'start_date': startDate,
      'end_date': endDate,
      'expire_date': expireDate,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Brand {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? name;
  String? imageUrl;

  Brand({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.imageUrl,
  });

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    image = json['image']?.toString();
    name = json['name']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image'] = image;
    data['name'] = name;
    data['image_url'] = imageUrl;
    return data;
  }
}

class HealthIssues {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? name;
  String? imageUrl;
  Pivot? pivot;

  HealthIssues({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.imageUrl,
    this.pivot,
  });

  HealthIssues.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    image = json['image']?.toString();
    name = json['name']?.toString();
    imageUrl = json['image_url']?.toString();
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image'] = image;
    data['name'] = name;
    data['image_url'] = imageUrl;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? productId;
  int? healthIssueId;

  Pivot({this.productId, this.healthIssueId});

  Pivot.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    healthIssueId = json['health_issue_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['health_issue_id'] = healthIssueId;
    return data;
  }
}
