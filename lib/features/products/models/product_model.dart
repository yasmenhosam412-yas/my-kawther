import 'package:elkawther/features/categories/models/category_products_model.dart';

double parseToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

double calculateDiscountPercentage(dynamic before, dynamic after) {
  final beforeValue = parseToDouble(before);
  final afterValue = parseToDouble(after);
  if (beforeValue <= 0) return 0.0;
  return ((beforeValue - afterValue) / beforeValue) * 100;
}

class ProductModel {
  int? id;
  String? name;
  String? description;
  double? price;
  int? quantity;
  double? rate;
  String? image;
  String? priceBeforeDiscount;
  String? priceAfterDiscount;
  String? discountType;
  bool? isFavorite;
  String? imageUrl;
  List<String>? images;
  double? averageRating;
  int? ratingsCount;
  Brand? brand;
  Category? category;
  List<HealthIssues>? healthIssues;
  List<SizeModel>? sizes;
  List<AvailableSize>? availableSizes;
  Saleable? saleable;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.quantity,
    this.rate,
    this.image,
    this.priceBeforeDiscount,
    this.priceAfterDiscount,
    this.discountType,
    this.isFavorite,
    this.imageUrl,
    this.images,
    this.averageRating,
    this.ratingsCount,
    this.brand,
    this.category,
    this.healthIssues,
    this.availableSizes,
    this.sizes,
    this.saleable,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // fallback logic
    final before = json['price_before_discount'] ?? json['final_price'];
    final after = json['price_after_discount'] ?? json['final_price'];

    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: parseToDouble(json['final_price']),
      quantity: json['quantity'],
      rate: parseToDouble(json['rate']),
      image: json['image'],
      priceBeforeDiscount: before?.toString(),
      priceAfterDiscount: after?.toString(),
      discountType: json['discount_type'],
      isFavorite:
          json['is_favorite'] is bool
              ? json['is_favorite']
              : json['is_favorite'] == 1,
      imageUrl: json['image_url'],
      images: (json['images'] as List?)?.map((e) => e.toString()).toList(),
      averageRating: parseToDouble(json['average_rating']),
      ratingsCount:
          json['ratings_count'] is int
              ? json['ratings_count']
              : int.tryParse(json['ratings_count']?.toString() ?? '0') ?? 0,
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      healthIssues:
          (json['health_issues'] as List?)
              ?.map((e) => HealthIssues.fromJson(e))
              .toList(),
      sizes:
          (json['sizes'] as List?)?.map((e) => SizeModel.fromJson(e)).toList(),
      availableSizes:
          (json['available_sizes'] as List?)
              ?.map((e) => AvailableSize.fromJson(e))
              .toList(),
      saleable:
          json['saleable'] != null ? Saleable.fromJson(json['saleable']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'quantity': quantity,
    'rate': rate,
    'image': image,
    'price_before_discount': priceBeforeDiscount,
    'price_after_discount': priceAfterDiscount,
    'discount_type': discountType,
    'discount_percentage': discountPercentage,
    'is_favorite': isFavorite,
    'image_url': imageUrl,
    'images': images,
    'average_rating': averageRating,
    'ratings_count': ratingsCount,
    'brand': brand?.toJson(),
    'category': category?.toJson(),
    'health_issues': healthIssues?.map((e) => e.toJson()).toList(),
    'sizes': sizes?.map((e) => e.toJson()).toList(),
    'available_sizes': availableSizes?.map((e) => e.toJson()).toList(),
    'saleable': saleable?.toJson(),
  };

  double get priceBeforeDiscountDouble => parseToDouble(priceBeforeDiscount);

  double get priceAfterDiscountDouble => parseToDouble(priceAfterDiscount);

  double get discountPercentage =>
      calculateDiscountPercentage(priceBeforeDiscount, priceAfterDiscount);
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'image': image,
    'name': name,
    'image_url': imageUrl,
  };
}

class Category {
  int? id;
  int? parentId;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? name;
  String? imageUrl;

  Category({
    this.id,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.imageUrl,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'parent_id': parentId,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'image': image,
    'name': name,
    'image_url': imageUrl,
  };
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    name = json['name'];
    imageUrl = json['image_url'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'image': image,
    'name': name,
    'image_url': imageUrl,
    if (pivot != null) 'pivot': pivot!.toJson(),
  };
}

class Pivot {
  int? productId;
  int? healthIssueId;

  Pivot({this.productId, this.healthIssueId});

  Pivot.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    healthIssueId = json['health_issue_id'];
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'health_issue_id': healthIssueId,
  };
}
