class TrackOrder {
  final bool success;
  final int orderId;
  final String status;
  final String statusMeaning;
  final String lastUpdate;

  TrackOrder({
    required this.success,
    required this.orderId,
    required this.status,
    required this.statusMeaning,
    required this.lastUpdate,
  });

  factory TrackOrder.fromJson(Map<String, dynamic> json) {
    return TrackOrder(
      success: json['success'] == true || json['success'] == 1,
      orderId: json['order_id'] is num
          ? (json['order_id'] as num).toInt()
          : int.tryParse('${json['order_id'] ?? json['id'] ?? 0}') ?? 0,
      status: '${json['status'] ?? ''}',
      statusMeaning: '${json['status_meaning'] ?? ''}',
      lastUpdate: '${json['last_update'] ?? json['updated_at'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'order_id': orderId,
      'status': status,
      'status_meaning': statusMeaning,
      'last_update': lastUpdate,
    };
  }
}
