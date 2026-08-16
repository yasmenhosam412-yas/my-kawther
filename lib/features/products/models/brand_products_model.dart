import 'package:elkawther/features/categories/models/category_products_model.dart';

double? parseToDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

class BrandProductsModel {
  String? status;
  String? message;
  List<BrandProduct>? products; // always extract products as a list
  int? count;

  BrandProductsModel({this.status, this.message, this.products, this.count});

  factory BrandProductsModel.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString();
    final message = json['message']?.toString();
    final count = json['count'];

    List<BrandProduct> products = [];

    final data = json['data'];
    if (data != null) {
      if (data is List) {
        // Case: data is directly a list of products
        products = data.map((x) => BrandProduct.fromJson(x)).toList();
      } else if (data is Map<String, dynamic>) {
        // Case: data contains nested products field
        if (data['products'] != null && data['products'] is List) {
          products =
              (data['products'] as List)
                  .map((x) => BrandProduct.fromJson(x))
                  .toList();
        }
      }
    }

    return BrandProductsModel(
      status: status,
      message: message,
      count: count,
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'count': count,
      'products': products?.map((x) => x.toJson()).toList(),
    };
  }
}

class Data {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? name;
  String? imageUrl;
  List<BrandProduct>? products;

  Data({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.imageUrl,
    this.products,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    image = json['image']?.toString();
    name = json['name']?.toString();
    imageUrl = json['image_url']?.toString();
    if (json['products'] != null) {
      products = List<BrandProduct>.from(
        json['products'].map((x) => BrandProduct.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['image'] = image;
    map['name'] = name;
    map['image_url'] = imageUrl;
    if (products != null) {
      map['products'] = products!.map((x) => x.toJson()).toList();
    }
    return map;
  }
}

class BrandProduct {
  int? id;
  double? rate;
  String? image;
  int? brandId;
  int? categoryId;
  String? saleableType;
  int? saleableId;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? description;
  bool? isFavorite;
  String? imageUrl;
  List<String>? images;
  double? averageRating;
  int? ratingsCount;
  double? finalPrice;
  String? discountType;
  Saleable? saleable;
  List<SizeModel>? sizes;
  List<AvailableSize>? availableSizes;
  Category? category;

  BrandProduct({
    this.id,
    this.rate,
    this.image,
    this.brandId,
    this.categoryId,
    this.saleableType,
    this.saleableId,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.description,
    this.isFavorite,
    this.imageUrl,
    this.images,
    this.averageRating,
    this.ratingsCount,
    this.finalPrice,
    this.discountType,
    this.saleable,
    this.sizes,
    this.availableSizes,
    this.category,
  });

  BrandProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rate = parseToDouble(json['rate']);
    image = json['image']?.toString();
    brandId = json['brand_id'];
    categoryId = json['category_id'];
    saleableType = json['saleable_type']?.toString();
    saleableId = json['saleable_id'];
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    name = json['name']?.toString();
    description = json['description']?.toString();
    isFavorite = json['is_favorite'];
    imageUrl = json['image_url']?.toString();
    images = (json['images'] as List?)?.map((x) => x.toString()).toList();
    averageRating = parseToDouble(json['average_rating']);
    ratingsCount = json['ratings_count'];
    finalPrice = parseToDouble(json['final_price']);
    discountType = json['discount_type']?.toString();

    if (json['saleable'] != null) {
      saleable = Saleable.fromJson(json['saleable']);
    }
    if (json['sizes'] != null) {
      sizes = List<SizeModel>.from(
        json['sizes'].map((x) => SizeModel.fromJson(x)),
      );
    }
    if (json['available_sizes'] != null) {
      availableSizes = List<AvailableSize>.from(
        json['available_sizes'].map((x) => AvailableSize.fromJson(x)),
      );
    }
    if (json['category'] != null) {
      category = Category.fromJson(json['category']);
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['rate'] = rate;
    map['image'] = image;
    map['brand_id'] = brandId;
    map['category_id'] = categoryId;
    map['saleable_type'] = saleableType;
    map['saleable_id'] = saleableId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['name'] = name;
    map['description'] = description;
    map['is_favorite'] = isFavorite;
    map['image_url'] = imageUrl;
    map['images'] = images;
    map['average_rating'] = averageRating;
    map['ratings_count'] = ratingsCount;
    map['final_price'] = finalPrice;
    map['discount_type'] = discountType;
    if (saleable != null) map['saleable'] = saleable!.toJson();
    if (sizes != null) map['sizes'] = sizes!.map((x) => x.toJson()).toList();
    if (availableSizes != null) {
      map['available_sizes'] = availableSizes!.map((x) => x.toJson()).toList();
    }
    if (category != null) map['category'] = category!.toJson();
    return map;
  }
}

class Category {
  int? id;
  String? name;
  String? image;
  String? imageUrl;

  Category({this.id, this.name, this.image, this.imageUrl});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']?.toString();
    image = json['image']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'image_url': imageUrl,
  };
}

class ProductSize {
  int? id;
  int? productId;
  String? size;
  String? price;
  int? stock;
  String? createdAt;
  String? updatedAt;

  ProductSize({
    this.id,
    this.productId,
    this.size,
    this.price,
    this.stock,
    this.createdAt,
    this.updatedAt,
  });

  ProductSize.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    size = json['size'];
    price = json['price']?.toString();
    stock = json['stock'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'size': size,
      'price': price,
      'stock': stock,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
