class NotificationModel {
  final int id;
  final int userId;
  final String body;
  final int isRead;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      body: json['body'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
    );
  }

  NotificationModel copyWith({
    int? id,
    int? userId,
    String? body,
    int? isRead,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
