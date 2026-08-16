class BannersModel {
  String? status;
  String? message;
  List<Data>? data;
  int? count;

  BannersModel({this.status, this.message, this.data, this.count});

  BannersModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    message = json['message']?.toString();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    count = json['count'];
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

class Data {
  int? id;
  String? image;
  String? link;
  int? status;
  int? orderOfAppearance;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? imageUrl;

  Data({
    this.id,
    this.image,
    this.link,
    this.status,
    this.orderOfAppearance,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.imageUrl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    link = json['link'];
    status = json['status'];
    orderOfAppearance = json['order_of_appearance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['link'] = link;
    data['status'] = status;
    data['order_of_appearance'] = orderOfAppearance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['title'] = title;
    data['image_url'] = imageUrl;
    return data;
  }
}
