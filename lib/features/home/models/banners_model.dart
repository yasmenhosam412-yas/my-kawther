int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

bool? _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'true':
      case '1':
        return true;
      case 'false':
      case '0':
        return false;
    }
  }
  return null;
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) {
    return DateTime(
      value.year,
      value.month,
      value.day,
      value.hour,
      value.minute,
      value.second,
      value.millisecond,
    );
  }

  final raw = value.toString().trim();
  if (raw.isEmpty || raw.toLowerCase() == 'null') return null;

  // Normalize Laravel-style "yyyy-MM-dd HH:mm:ss" into ISO-8601.
  var normalized = raw.contains('T') ? raw : raw.replaceFirst(' ', 'T');
  normalized = normalized.replaceFirst(' ', 'T');

  final parsed =
      DateTime.tryParse(normalized) ??
      DateTime.tryParse('${normalized}Z') ??
      DateTime.tryParse(normalized.replaceAll('/', '-'));
  if (parsed == null) return null;

  // Use wall-clock time as local. Admin panels often store local times with a
  // trailing Z, so comparing as UTC hides active banners incorrectly.
  return DateTime(
    parsed.year,
    parsed.month,
    parsed.day,
    parsed.hour,
    parsed.minute,
    parsed.second,
    parsed.millisecond,
  );
}

class BannerPosition {
  static const home = 'home';
  static const offers = 'offers';
  static const category = 'category';
  static const homeMiddle = 'home_middle';
  static const homeBottom = 'home_bottom';

  static String normalize(String? value) {
    final raw = (value ?? home).trim().toLowerCase().replaceAll('-', '_');
    switch (raw) {
      case 'offer':
      case 'offers':
      case 'on_sale':
      case 'sale':
        return offers;
      case 'category':
      case 'categories':
      case 'catgory':
        return category;
      case 'home_middle':
      case 'homemiddle':
      case 'middle':
        return homeMiddle;
      case 'home_bottom':
      case 'homebottom':
      case 'bottom':
        return homeBottom;
      case 'home':
      case 'home_top':
      case 'top':
        return home;
      default:
        return raw;
    }
  }
}

class BannersModel {
  String? status;
  String? message;
  List<BannerData>? data;
  int? count;

  BannersModel({this.status, this.message, this.data, this.count});

  BannersModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    message = json['message']?.toString();
    if (json['data'] != null) {
      data = <BannerData>[];
      json['data'].forEach((v) {
        data!.add(BannerData.fromJson(v));
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

  List<BannerData> bannersFor(
    String position, {
    DateTime? now,
    String? device,
  }) {
    final at = now ?? DateTime.now();
    final items =
        (data ?? const <BannerData>[])
            .where(
              (banner) =>
                  banner.matchesPosition(position) &&
                  banner.isVisibleAt(at, device: device),
            )
            .toList()
          ..sort(
            (a, b) => (a.orderOfAppearance ?? 0).compareTo(
              b.orderOfAppearance ?? 0,
            ),
          );
    return items;
  }
}

class BannerData {
  int? id;
  String? image;
  String? link;
  bool? status;
  int? orderOfAppearance;
  String? createdAt;
  String? updatedAt;
  String? position;
  DateTime? startsAt;
  DateTime? endsAt;
  int? countryId;
  String? device;
  String? title;
  String? description;
  String? imageUrl;

  BannerData({
    this.id,
    this.image,
    this.link,
    this.status,
    this.orderOfAppearance,
    this.createdAt,
    this.updatedAt,
    this.position,
    this.startsAt,
    this.endsAt,
    this.countryId,
    this.device,
    this.title,
    this.description,
    this.imageUrl,
  });

  BannerData.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    image = json['image']?.toString();
    link = json['link']?.toString();
    status = _parseBool(json['status']);
    orderOfAppearance = _parseInt(json['order_of_appearance']);
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    position = json['position']?.toString();
    startsAt = _parseDateTime(json['starts_at']);
    endsAt = _parseDateTime(json['ends_at']);
    countryId = _parseInt(json['country_id']);
    device = json['device']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    imageUrl = json['image_url']?.toString();
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
    data['position'] = position;
    data['starts_at'] = startsAt?.toIso8601String();
    data['ends_at'] = endsAt?.toIso8601String();
    data['country_id'] = countryId;
    data['device'] = device;
    data['title'] = title;
    data['description'] = description;
    data['image_url'] = imageUrl;
    return data;
  }

  bool matchesPosition(String target) {
    return BannerPosition.normalize(position) ==
        BannerPosition.normalize(target);
  }

  bool get hasSchedule => startsAt != null || endsAt != null;

  /// Inclusive window: visible when `starts_at <= now <= ends_at`.
  /// Null bounds mean no limit on that side.
  bool isWithinSchedule([DateTime? now]) {
    final at = now ?? DateTime.now();
    final start = startsAt;
    final end = endsAt;

    if (start != null && at.isBefore(start)) return false;
    if (end != null && at.isAfter(end)) return false;
    return true;
  }

  bool isVisibleAt(DateTime now, {String? device}) {
    if (status == false) return false;
    if (!isWithinSchedule(now)) return false;

    final requiredDevice = this.device?.trim().toLowerCase();
    if (requiredDevice != null &&
        requiredDevice.isNotEmpty &&
        requiredDevice != 'all' &&
        device != null &&
        device.trim().toLowerCase() != requiredDevice) {
      return false;
    }

    return true;
  }
}

/// Backward-compatible alias used by older call sites.
typedef Data = BannerData;
