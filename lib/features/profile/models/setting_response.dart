class SettingsResponse {
  final String status;
  final String message;
  final List<BrandSettings> data;
  final int count;

  SettingsResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.count,
  });

  factory SettingsResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List<dynamic>? ?? [];
    List<BrandSettings> brands =
        dataList.map((e) => BrandSettings.fromJson(e)).toList();

    return SettingsResponse(
      status: json['status'],
      message: json['message'],
      data: brands,
      count: json['count'] ?? 0,
    );
  }
}

class BrandSettings {
  final int id;
  final String? facebook;
  final String? instagram;
  final String? tiktok;
  final String? youtube;
  final String? phoneNumber;
  final String? mapLocationUrl;
  final String? spendX;
  final String? getY;
  final String? zaincash;
  final String? keyCard;
  final String? privacyPolicy;
  final String? termsConditions;

  BrandSettings({
    required this.id,
    this.facebook,
    this.instagram,
    this.tiktok,
    this.youtube,
    this.phoneNumber,
    this.mapLocationUrl,
    this.spendX,
    this.getY,
    this.zaincash,
    this.keyCard,
    this.privacyPolicy,
    this.termsConditions,
  });

  factory BrandSettings.fromJson(Map<String, dynamic> json) {
    return BrandSettings(
      id: json['id'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      tiktok: json['tiktok'],
      youtube: json['youtube'],
      phoneNumber: json['phone_number'],
      mapLocationUrl: json['map_location_url'],
      spendX: json['spend_x'],
      getY: json['get_y'],
      zaincash: json['zaincash'],
      keyCard: json['keycard'],
      privacyPolicy: json['privacy_policy'],
      termsConditions: json['terms_conditions'],
    );
  }
}
