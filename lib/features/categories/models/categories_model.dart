int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

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
        status: json['status']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        count: _parseInt(json['count']),
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
    id:
        _parseInt(json['id']) ??
        (throw const FormatException('Category id must be an integer.')),
    parentId: _parseInt(json['parent_id']),
    createdAt: json['created_at']?.toString() ?? '',
    updatedAt: json['updated_at']?.toString() ?? '',
    image: json['image']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    imageUrl: json['image_url']?.toString() ?? '',
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
    id:
        _parseInt(json['id']) ??
        (throw const FormatException('Subcategory id must be an integer.')),
    parentId:
        _parseInt(json['parent_id']) ??
        (throw const FormatException(
          'Subcategory parent_id must be an integer.',
        )),
    createdAt: json['created_at']?.toString() ?? '',
    updatedAt: json['updated_at']?.toString() ?? '',
    image: json['image']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    imageUrl: json['image_url']?.toString() ?? '',
  );
}
