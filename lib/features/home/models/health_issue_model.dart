class HealthIssueModel {
  String? status;
  String? message;
  List<HealthIssueData>? data;
  int? count;

  HealthIssueModel({this.status, this.message, this.data, this.count});

  HealthIssueModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HealthIssueData>[];
      json['data'].forEach((v) {
        data!.add(HealthIssueData.fromJson(v));
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

class HealthIssueData {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? name;
  String? imageUrl;

  HealthIssueData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.imageUrl,
  });

  HealthIssueData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    name = json['name'];
    imageUrl = json['image_url'];
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
