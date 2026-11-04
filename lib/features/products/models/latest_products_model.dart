import 'package:elkawther/features/categories/models/category_products_model.dart';

int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

String? _parseString(dynamic value) => value?.toString();

class LatestProductsModel {
  String? status;
  String? message;
  List<LatestProductsData>? data;
  int? count;

  LatestProductsModel({this.status, this.message, this.data, this.count});

  factory LatestProductsModel.fromJson(Map<String, dynamic> json) {
    return LatestProductsModel(
      status: _parseString(json['status']),
      message: _parseString(json['message']),
      count: _parseInt(json['count']),
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => LatestProductsData.fromJson(item))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'count': count,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class LatestProductsData {
  int? id;
  String? name;
  String? description;
  String? image;
  String? imageUrl;
  List<String>? images;
  double? finalPrice;
  double? rate;
  bool? isFavorite;
  double? averageRating;
  int? ratingsCount;
  String? discountType;
  Brand? brand;
  Category? category;
  List<AvailableSize>? availableSizes;
  List<SizeModel>? sizes;
  List<ProductImage>? productImages;
  Saleable? saleable;

  LatestProductsData({
    this.id,
    this.name,
    this.description,
    this.image,
    this.imageUrl,
    this.images,
    this.finalPrice,
    this.rate,
    this.isFavorite,
    this.averageRating,
    this.ratingsCount,
    this.discountType,
    this.brand,
    this.category,
    this.availableSizes,
    this.sizes,
    this.productImages,
    this.saleable,
  });

  factory LatestProductsData.fromJson(Map<String, dynamic> json) {
    return LatestProductsData(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      description: _parseString(json['description']),
      image: _parseString(json['image']),
      imageUrl: _parseString(json['image_url']),
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      finalPrice:
          (json['final_price'] != null)
              ? double.tryParse(json['final_price'].toString())
              : null,
      rate: json['rate'] != null ? double.tryParse('${json['rate']}') : null,
      isFavorite:
          json['is_favorite'] is bool
              ? json['is_favorite']
              : json['is_favorite'] == 1 || json['is_favorite'] == '1',
      averageRating:
          (json['average_rating'] != null)
              ? double.tryParse('${json['average_rating']}')
              : null,
      ratingsCount: _parseInt(json['ratings_count']),
      discountType: _parseString(json['discount_type']),
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      availableSizes:
          (json['available_sizes'] as List<dynamic>?)
              ?.map((e) => AvailableSize.fromJson(e))
              .toList(),
      sizes:
          (json['sizes'] as List<dynamic>?)
              ?.map((e) => SizeModel.fromJson(e))
              .toList(),
      productImages:
          (json['product_images'] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList(),
      saleable:
          json['saleable'] != null ? Saleable.fromJson(json['saleable']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image,
    'image_url': imageUrl,
    'images': images,
    'final_price': finalPrice,
    'rate': rate,
    'is_favorite': isFavorite,
    'average_rating': averageRating,
    'ratings_count': ratingsCount,
    'discount_type': discountType,
    'brand': brand?.toJson(),
    'category': category?.toJson(),
    'available_sizes': availableSizes?.map((e) => e.toJson()).toList(),
    'sizes': sizes?.map((e) => e.toJson()).toList(),
    'product_images': productImages?.map((e) => e.toJson()).toList(),
  };
}

class Brand {
  int? id;
  String? name;
  String? image;
  String? imageUrl;

  Brand({this.id, this.name, this.image, this.imageUrl});

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: _parseInt(json['id']),
    name: _parseString(json['name']),
    image: _parseString(json['image']),
    imageUrl: _parseString(json['image_url']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'image_url': imageUrl,
  };
}

class Category {
  int? id;
  String? name;
  String? image;
  String? imageUrl;

  Category({this.id, this.name, this.image, this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: _parseInt(json['id']),
    name: _parseString(json['name']),
    image: _parseString(json['image']),
    imageUrl: _parseString(json['image_url']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'image_url': imageUrl,
  };
}

class ProductSize {
  String? size;
  double? originalPrice;
  double? price;
  int? stock;

  ProductSize({this.size, this.originalPrice, this.price, this.stock});

  factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
    size: _parseString(json['size']),
    originalPrice:
        json['original_price'] != null
            ? double.tryParse(json['original_price'].toString())
            : null,
    price:
        json['price'] != null
            ? double.tryParse(json['price'].toString())
            : null,
    stock: _parseInt(json['stock']),
  );

  Map<String, dynamic> toJson() => {
    'size': size,
    'original_price': originalPrice,
    'price': price,
    'stock': stock,
  };
}

class ProductImage {
  int? id;
  int? productId;
  String? imagePath;
  String? imageUrl;

  ProductImage({this.id, this.productId, this.imagePath, this.imageUrl});

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    id: _parseInt(json['id']),
    productId: _parseInt(json['product_id']),
    imagePath: _parseString(json['image_path']),
    imageUrl: _parseString(json['image_url']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'image_path': imagePath,
    'image_url': imageUrl,
  };
}
