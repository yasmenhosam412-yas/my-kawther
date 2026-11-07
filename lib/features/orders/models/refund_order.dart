class RefundOrder {
  final int userId;
  final String orderId;
  final String reason;
  final String? note;
  final String refundAmount;
  final String refundMethod;
  final String address;
  final String updatedAt;
  final String createdAt;
  final int id;

  RefundOrder({
    required this.userId,
    required this.orderId,
    required this.reason,
    required this.note,
    required this.refundAmount,
    required this.refundMethod,
    required this.address,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory RefundOrder.fromJson(Map<String, dynamic> json) {
    final body = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    String text(dynamic value) => value?.toString() ?? '';
    int asInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    return RefundOrder(
      userId: asInt(body['user_id']),
      orderId: text(body['order_id']),
      reason: text(body['reason']),
      note: body['note']?.toString(),
      refundAmount: text(body['refund_amount']),
      refundMethod: text(body['refund_method']),
      address: text(body['address']),
      updatedAt: text(body['updated_at']),
      createdAt: text(body['created_at']),
      id: asInt(body['id']),
    );
  }
}
