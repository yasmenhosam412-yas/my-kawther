int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

class BrandsModel {
  String? status;
  String? message;
  List<BrandsData>? data;
  int? count;

  BrandsModel({this.status, this.message, this.data, this.count});

  BrandsModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    message = json['message']?.toString();
    if (json['data'] != null) {
      data = <BrandsData>[];
      json['data'].forEach((v) {
        data!.add(BrandsData.fromJson(v));
      });
    }
    count = _parseInt(json['count']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class BrandsData {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? name;
  String? imageUrl;

  BrandsData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.imageUrl,
  });

  BrandsData.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
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
