class ContactMessage {
  const ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    this.status,
    this.createdAt,
    this.replies = const [],
  });

  final int id;
  final String name;
  final String email;
  final String message;
  final String? status;
  final String? createdAt;
  final List<ContactReply> replies;

  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    final nested = json['replies'];
    return ContactMessage(
      id: _asInt(json['id'] ?? json['contact_message_id']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      message: _text(json),
      status: json['status']?.toString(),
      createdAt: _date(json),
      replies:
          nested is List
              ? nested
                  .whereType<Map>()
                  .map(
                    (item) => ContactReply.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  )
                  .toList()
              : const [],
    );
  }
}

class ContactReply {
  const ContactReply({
    required this.id,
    required this.message,
    required this.isMine,
    this.createdAt,
  });

  final int id;
  final String message;
  final bool isMine;
  final String? createdAt;

  factory ContactReply.fromJson(Map<String, dynamic> json) {
    return ContactReply(
      id: _asInt(json['id']),
      message: _text(json),
      isMine: _isMine(json),
      createdAt: _date(json),
    );
  }
}

String formatContactDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return raw;
  final local = parsed.toLocal();
  String two(int value) => value.toString().padLeft(2, '0');
  return '${local.year}-${two(local.month)}-${two(local.day)} ${two(local.hour)}:${two(local.minute)}';
}

List<ContactMessage> parseContactMessages(dynamic raw) {
  return _asMaps(raw).map(ContactMessage.fromJson).toList();
}

ContactMessage parseContactMessage(dynamic raw) {
  if (raw is Map) {
    final body = Map<String, dynamic>.from(raw);
    for (final key in ['data', 'contact_message', 'message']) {
      final value = body[key];
      if (value is Map &&
          (value.containsKey('id') ||
              value.containsKey('email') ||
              value.containsKey('message') ||
              value.containsKey('body'))) {
        return ContactMessage.fromJson(Map<String, dynamic>.from(value));
      }
    }
    if (body.containsKey('id') || body.containsKey('email')) {
      return ContactMessage.fromJson(body);
    }
  }
  throw const FormatException('Unexpected contact message response');
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? 0;
}

String _text(Map<String, dynamic> json) {
  for (final key in ['message', 'body', 'content', 'reply', 'text']) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
  }
  return '';
}

String? _date(Map<String, dynamic> json) {
  final value = json['created_at'] ?? json['createdAt'] ?? json['date'];
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

bool _isMine(Map<String, dynamic> json) {
  if (json['is_admin'] == true || json['is_support'] == true) return false;
  if (json['is_user'] == true || json['is_mine'] == true) return true;
  final sender =
      (json['sender'] ?? json['from'] ?? json['type'] ?? json['role'] ?? '')
          .toString()
          .toLowerCase();
  if (sender.contains('admin') ||
      sender.contains('support') ||
      sender.contains('staff')) {
    return false;
  }
  if (sender.contains('user') ||
      sender.contains('customer') ||
      sender.contains('client')) {
    return true;
  }
  return false;
}

List<Map<String, dynamic>> _asMaps(dynamic raw) {
  if (raw is List) {
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
  if (raw is Map) {
    final body = Map<String, dynamic>.from(raw);
    for (final key in [
      'data',
      'messages',
      'contact_messages',
      'items',
      'replies',
    ]) {
      final value = body[key];
      if (value is List) return _asMaps(value);
      if (value is Map && value['data'] is List) {
        return _asMaps(value['data']);
      }
    }
  }
  return const [];
}
