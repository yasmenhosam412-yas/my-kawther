class AdsModel {
  final int? id;
  final String? imageUrl;
  final bool isActive;
  final String? title;
  final String? content;
  final String? link;
  final String displayFrequency;
  final int priority;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String device;

  const AdsModel({
    this.id,
    required this.imageUrl,
    required this.isActive,
    this.title,
    this.content,
    this.link,
    this.displayFrequency = 'every_open',
    this.priority = 0,
    this.startsAt,
    this.endsAt,
    this.device = 'all',
  });

  bool get isScheduled {
    final now = DateTime.now();
    if (startsAt != null && now.isBefore(startsAt!)) return false;
    if (endsAt != null && !now.isBefore(endsAt!)) return false;
    return true;
  }

  bool matchesDevice(String deviceName) {
    final target = device.trim().toLowerCase();
    return target.isEmpty || target == 'all' || target == deviceName;
  }

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final active = json['is_active'];
    final priority = json['priority'];

    return AdsModel(
      id: id is num ? id.toInt() : int.tryParse(id?.toString() ?? ''),
      imageUrl: _stringOrNull(json['image_url'] ?? json['image']),
      isActive:
          active == true ||
          active == 1 ||
          active?.toString().toLowerCase() == 'true' ||
          active?.toString() == '1',
      title: _stringOrNull(json['title']),
      content: _stringOrNull(json['content']),
      link: _stringOrNull(json['link']),
      displayFrequency: _frequency(json['display_frequency']),
      priority: priority is num
          ? priority.toInt()
          : int.tryParse(priority?.toString() ?? '') ?? 0,
      startsAt: DateTime.tryParse(json['starts_at']?.toString() ?? ''),
      endsAt: DateTime.tryParse(json['ends_at']?.toString() ?? ''),
      device: _stringOrNull(json['device']) ?? 'all',
    );
  }
}

String _frequency(dynamic value) {
  final raw = value
      ?.toString()
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[\s-]+'), '_');
  switch (raw) {
    case 'once':
      return 'once';
    case 'per_day':
    case 'once_per_day':
    case 'daily':
      return 'once_per_day';
    case 'per_session':
    case 'once_per_session':
    case 'session':
      return 'once_per_session';
    case 'every_time':
    case 'every_open':
    case 'everytime':
    case 'always':
      return 'every_open';
    default:
      return 'every_open';
  }
}

String? _stringOrNull(dynamic value) {
  if (value is! String || value.trim().isEmpty) return null;
  return value.trim();
}
