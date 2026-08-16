class CategoryProductsModel {
  String? status;
  String? message;
  List<CategoryProductsData>? data;
  int? count;

  CategoryProductsModel({this.status, this.message, this.data, this.count});

  CategoryProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryProductsData>[];
      json['data'].forEach((v) {
        data!.add(CategoryProductsData.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class CategoryProductsModelFilter {
  bool? status;
  String? message;
  List<CategoryProductsData>? data;
  int? count;

  CategoryProductsModelFilter({
    this.status,
    this.message,
    this.data,
    this.count,
  });

  CategoryProductsModelFilter.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryProductsData>[];
      json['data'].forEach((v) {
        data!.add(CategoryProductsData.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class CategoryProductsData {
  int? id;
  String? price;
  int? quantity;
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
  Saleable? saleable;
  int? priceBeforeDiscount;
  double? priceAfterDiscount;
  String? discountPercentage;
  String? categoryName;
  double? finalPrice;
  String? discountType;
  List<AvailableSize>? availableSizes;
  List<SizeModel>? sizes;
  CategoryModel? category;

  CategoryProductsData({
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
    this.name,
    this.description,
    this.isFavorite,
    this.imageUrl,
    this.images,
    this.averageRating,
    this.ratingsCount,
    this.saleable,
    this.priceBeforeDiscount,
    this.priceAfterDiscount,
    this.discountPercentage,
    this.categoryName,
    this.finalPrice,
    this.discountType,
    this.availableSizes,
    this.sizes,
    this.category,
  });

  CategoryProductsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    quantity = json['quantity'];
    rate =
        json['rate'] != null ? double.tryParse(json['rate'].toString()) : null;
    image = json['image'];
    brandId = json['brand_id'];
    categoryId = json['category_id'];
    saleableType = json['saleable_type'];
    saleableId = json['saleable_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    description = json['description'];
    isFavorite = json['is_favorite'];
    imageUrl = json['image_url'];
    images = json['images']?.cast<String>();
    averageRating =
        json['average_rating'] != null
            ? double.tryParse(json['average_rating'].toString())
            : null;
    ratingsCount = json['ratings_count'];
    saleable =
        json['saleable'] != null ? Saleable.fromJson(json['saleable']) : null;
    priceBeforeDiscount = json['price_before_discount'];
    priceAfterDiscount =
        json['price_after_discount'] != null
            ? double.tryParse(json['price_after_discount'].toString())
            : null;
    discountPercentage = json['discount_percentage'];
    categoryName = json['category_name'];
    finalPrice =
        json['final_price'] != null
            ? double.tryParse(json['final_price'].toString())
            : null;
    discountType = json['discount_type'];
    availableSizes =
        (json['available_sizes'] as List?)
            ?.map((x) => AvailableSize.fromJson(x))
            .toList() ??
        [];
    sizes =
        (json['sizes'] as List?)?.map((x) => SizeModel.fromJson(x)).toList() ??
        [];

    category =
        json['category'] != null
            ? CategoryModel.fromJson(json['category'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['price'] = price;
    data['quantity'] = quantity;
    data['rate'] = rate;
    data['image'] = image;
    data['brand_id'] = brandId;
    data['category_id'] = categoryId;
    data['saleable_type'] = saleableType;
    data['saleable_id'] = saleableId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['name'] = name;
    data['description'] = description;
    data['is_favorite'] = isFavorite;
    data['image_url'] = imageUrl;
    data['images'] = images;
    data['average_rating'] = averageRating;
    data['ratings_count'] = ratingsCount;
    if (saleable != null) data['saleable'] = saleable!.toJson();
    data['price_before_discount'] = priceBeforeDiscount;
    data['price_after_discount'] = priceAfterDiscount;
    data['discount_percentage'] = discountPercentage;
    data['category_name'] = categoryName;
    data['final_price'] = finalPrice;
    data['discount_type'] = discountType;
    if (availableSizes != null) {
      data['available_sizes'] = availableSizes!.map((x) => x.toJson()).toList();
    }
    if (sizes != null) {
      data['sizes'] = sizes!.map((x) => x.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Saleable {
  int? id;
  String? discountValue;
  int? isActive;
  String? date;
  String? time;
  String? createdAt;
  String? updatedAt;
  String? startsAt;
  String? endsAt;

  Saleable({
    this.id,
    this.discountValue,
    this.isActive,
    this.date,
    this.time,
    this.createdAt,
    this.updatedAt,
    this.startsAt,
    this.endsAt,
  });

  Saleable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    discountValue = json['discount_value'];
    isActive = json['is_active'];
    date = json['date'];
    time = json['time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    startsAt = json['starts_at'];
    endsAt = json['ends_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discount_value': discountValue,
      'is_active': isActive,
      'date': date,
      'time': time,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'starts_at': startsAt,
      'ends_at': endsAt,
    };
  }
}

class AvailableSize {
  int? id;
  String? size;
  double? originalPrice;
  double? price;
  int? stock;
  String? discountType;
  String? discountValue;
  double? priceAfterDiscount;

  AvailableSize({
    this.id,
    this.size,
    this.originalPrice,
    this.price,
    this.stock,
    this.discountType,
    this.discountValue,
    this.priceAfterDiscount,
  });

  factory AvailableSize.fromJson(Map<String, dynamic> json) {
    return AvailableSize(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id']?.toString() ?? ''),
      size: json['size']?.toString(),
      price: _parseToDouble(json['price']),
      originalPrice: _parseToDouble(json['original_price']),
      priceAfterDiscount: _parseToDouble(json['price_after_discount']),
      stock:
          json['stock'] is int
              ? json['stock']
              : int.tryParse(json['stock']?.toString() ?? ''),
      discountType: json['discount_type']?.toString(),
      discountValue: json['discount_value']?.toString(),
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

  static double? _parseToDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class SizeModel {
  int? id;
  int? productId;
  String? size;
  String? price;
  int? stock;
  String? createdAt;
  String? updatedAt;

  SizeModel({
    this.id,
    this.productId,
    this.size,
    this.price,
    this.stock,
    this.createdAt,
    this.updatedAt,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: json['id'],
      productId: json['product_id'],
      size: json['size'],
      price: json['price'],
      stock: json['stock'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
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

class CategoryModel {
  int? id;
  int? parentId;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? name;
  String? imageUrl;

  CategoryModel({
    this.id,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      parentId: json['parent_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      image: json['image'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image': image,
      'name': name,
      'image_url': imageUrl,
    };
  }
}
