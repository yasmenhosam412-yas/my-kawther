import 'package:elkawther/features/categories/models/category_products_model.dart';

class HealthIssueProductsModel {
  bool? status;
  String? message;
  Data? data;
  List<HealthIssueProducts>? dataHealth; // for list root API
  int? count;

  HealthIssueProductsModel({
    this.status,
    this.message,
    this.data,
    this.dataHealth,
    this.count,
  });

  HealthIssueProductsModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      status = json['status'] is bool ? json['status'] : null;
      message = json['message']?.toString();

      // Case: data is a Map with products inside
      if (json['data'] != null) {
        if (json['data'] is Map<String, dynamic>) {
          data = Data.fromJson(json['data']);
        }
        // Case: data is a List
        else if (json['data'] is List) {
          dataHealth =
              (json['data'] as List)
                  .map((e) => HealthIssueProducts.fromJson(e))
                  .toList();
        }
      }

      count = int.tryParse(json['count']?.toString() ?? '0');
    }
    // Case: root is a list
    else if (json is List) {
      status = true;
      message = 'success';
      dataHealth = json.map((e) => HealthIssueProducts.fromJson(e)).toList();
      count = dataHealth?.length ?? 0;
    }
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson() ?? dataHealth?.map((e) => e.toJson()).toList(),
    'count': count,
  };
}

class Data {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? image;
  List<HealthIssueProducts>? products;
  String? name;
  String? imageUrl;

  Data({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.products,
    this.name,
    this.imageUrl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '0');
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    image = json['image']?.toString();
    name = json['name']?.toString();
    imageUrl = json['image_url']?.toString();

    if (json['products'] != null && json['products'] is List) {
      products =
          (json['products'] as List)
              .map((e) => HealthIssueProducts.fromJson(e))
              .toList();
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'image': image,
    'name': name,
    'image_url': imageUrl,
    'products': products?.map((e) => e.toJson()).toList(),
  };
}

// HealthIssueProducts class remains the same as your original
class HealthIssueProducts {
  int? id;
  double? price;
  int? quantity;
  double? rate;
  String? image;
  int? brandId;
  int? categoryId;
  String? saleableType;
  int? saleableId;
  String? createdAt;
  String? updatedAt;
  double? priceBeforeDiscount;
  double? priceAfterDiscount;
  String? discountType;
  String? categoryName;
  String? name;
  String? description;
  bool? isFavorite;
  String? imageUrl;
  List<String>? images;
  double? averageRating;
  int? ratingsCount;
  Pivot? pivot;
  Saleable? saleable;
  List<SizeModel>? sizes;
  List<AvailableSize>? avaiableSize;
  int? totalSold;

  HealthIssueProducts({
    this.id,
    this.price,
    this.quantity,
    this.rate,
    this.image,
    this.brandId,
    this.categoryId,
    this.saleableType,
    this.saleableId,
    this.createdAt,
    this.updatedAt,
    this.priceBeforeDiscount,
    this.priceAfterDiscount,
    this.discountType,
    this.categoryName,
    this.name,
    this.description,
    this.isFavorite,
    this.imageUrl,
    this.images,
    this.averageRating,
    this.ratingsCount,
    this.pivot,
    this.saleable,
    this.sizes,
    this.avaiableSize,
    this.totalSold,
  });

  HealthIssueProducts.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '0');
    price = parseToDouble(json['final_price']);
    quantity = int.tryParse(json['quantity']?.toString() ?? '0');
    rate = parseToDouble(json['rate']);
    image = json['image']?.toString();
    brandId = int.tryParse(json['brand_id']?.toString() ?? '0');
    categoryId = int.tryParse(json['category_id']?.toString() ?? '0');
    saleableType = json['saleable_type']?.toString();
    saleableId = int.tryParse(json['saleable_id']?.toString() ?? '0');
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    priceBeforeDiscount = parseToDouble(json['price_before_discount']);
    priceAfterDiscount = parseToDouble(json['price_after_discount']);
    discountType = json['discount_type']?.toString();
    categoryName = json['category_name']?.toString();
    name = json['name']?.toString();
    description = json['description']?.toString();
    isFavorite = json['is_favorite'] is bool ? json['is_favorite'] : false;
    imageUrl = json['image_url']?.toString();
    images = (json['images'] as List?)?.map((e) => e.toString()).toList();
    averageRating = parseToDouble(json['average_rating'] ?? json['rate']);
    ratingsCount = int.tryParse(json['ratings_count']?.toString() ?? '0');
    totalSold = int.tryParse(json['total_sold']?.toString() ?? '0');
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
    saleable =
        json['saleable'] != null ? Saleable.fromJson(json['saleable']) : null;
    sizes =
        (json['sizes'] as List?)?.map((e) => SizeModel.fromJson(e)).toList();
    avaiableSize =
        (json['available_sizes'] as List?)
            ?.map((e) => AvailableSize.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'price': price,
    'quantity': quantity,
    'rate': rate,
    'image': image,
    'brand_id': brandId,
    'category_id': categoryId,
    'saleable_type': saleableType,
    'saleable_id': saleableId,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'price_before_discount': priceBeforeDiscount,
    'price_after_discount': priceAfterDiscount,
    'discount_type': discountType,
    'category_name': categoryName,
    'name': name,
    'description': description,
    'is_favorite': isFavorite,
    'image_url': imageUrl,
    'images': images,
    'average_rating': averageRating,
    'ratings_count': ratingsCount,
    'pivot': pivot?.toJson(),
    'saleable': saleable?.toJson(),
    'sizes': sizes?.map((e) => e.toJson()).toList(),
    'available_sizes': avaiableSize?.map((e) => e.toJson()).toList(),
    'total_sold': totalSold,
  };
}

// Pivot class
class Pivot {
  int? healthIssueId;
  int? productId;

  Pivot({this.healthIssueId, this.productId});

  Pivot.fromJson(Map<String, dynamic> json) {
    healthIssueId = int.tryParse(json['health_issue_id']?.toString() ?? '0');
    productId = int.tryParse(json['product_id']?.toString() ?? '0');
  }

  Map<String, dynamic> toJson() => {
    'health_issue_id': healthIssueId,
    'product_id': productId,
  };
}

double parseToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
