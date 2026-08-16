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
    return RefundOrder(
      userId: json['user_id'],
      orderId: json['order_id'],
      reason: json['reason'],
      note: json['note'],
      refundAmount: json['refund_amount'],
      refundMethod: json['refund_method'],
      address: json['address'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }
}
