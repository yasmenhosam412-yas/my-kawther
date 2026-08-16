class OrderModel {
  final int orderId;
  final double totalPrice;
  final int pointsEarned;
  final String? giftDescription;
  final String message;

  OrderModel({
    required this.orderId,
    required this.totalPrice,
    required this.pointsEarned,
    this.giftDescription,
    required this.message,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? 0,
      totalPrice: (json['total_price'] as num).toDouble(),
      pointsEarned: json['points_earned'] ?? 0,
      giftDescription: json['gift_description'],
      message: json['message'] ?? '',
    );
  }
}
