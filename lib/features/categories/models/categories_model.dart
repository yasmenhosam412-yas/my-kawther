class CategoriesModel {
  final String status;
  final String message;
  final List<CategoryData> data;
  final int? count;

  CategoriesModel({
    required this.status,
    required this.message,
    required this.data,
    required this.count,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        status: json['status'],
        message: json['message'],
        count: json['count'],
        data: List<CategoryData>.from(
          (json['data'] ?? []).map((e) => CategoryData.fromJson(e)),
        ),
      );
}

class CategoryData {
  final int id;
  final int? parentId;
  final String createdAt;
  final String updatedAt;
  final String image;
  final String name;
  final String imageUrl;
  final List<Subcategory> subcategories;

  CategoryData({
    required this.id,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.name,
    required this.imageUrl,
    required this.subcategories,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
    id: json['id'],
    parentId: json['parent_id'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    image: json['image'],
    name: json['name'],
    imageUrl: json['image_url'],
    subcategories: List<Subcategory>.from(
      (json['subcategories'] ?? []).map((e) => Subcategory.fromJson(e)),
    ),
  );
}

class Subcategory {
  final int id;
  final int parentId;
  final String createdAt;
  final String updatedAt;
  final String image;
  final String name;
  final String imageUrl;

  Subcategory({
    required this.id,
    required this.parentId,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.name,
    required this.imageUrl,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    id: json['id'],
    parentId: json['parent_id'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    image: json['image'],
    name: json['name'],
    imageUrl: json['image_url'],
  );
}
