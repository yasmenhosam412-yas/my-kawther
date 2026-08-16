class AdsModel {
  final String imageUrl;
  bool isActive;

  AdsModel({required this.imageUrl, required this.isActive});

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(imageUrl: json['image_url'], isActive: json['is_active']);
  }
}
