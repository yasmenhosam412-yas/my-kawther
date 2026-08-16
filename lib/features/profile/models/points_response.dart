class PointsResponse {
  final int totalPoints;
  final List<OrderPoints> orders;

  PointsResponse({required this.totalPoints, required this.orders});

  factory PointsResponse.fromJson(Map<String, dynamic> json) {
    final ordersJson = json['orders'] as List<dynamic>? ?? [];
    final ordersList = ordersJson.map((e) => OrderPoints.fromJson(e)).toList();

    final total =
        json['valid_points_total'] ??
        json['consumed_points_total'] ??
        json['expired_points_total'] ??
        0;

    return PointsResponse(totalPoints: total, orders: ordersList);
  }
}

class OrderPoints {
  final String orderName;
  final int pointsEarned;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final DateTime? expiredAt;
  final DateTime? redeemedAt;

  OrderPoints({
    required this.orderName,
    required this.pointsEarned,
    required this.createdAt,
    this.expiresAt,
    this.redeemedAt,
    this.expiredAt,
  });

  factory OrderPoints.fromJson(Map<String, dynamic> json) {
    DateTime? expires;
    if (json['expires_at'] != null &&
        (json['expires_at'] as String).isNotEmpty) {
      expires = DateTime.tryParse(json['expires_at']);
    }

    DateTime? redeemed;
    if (json['redeemed_at'] != null &&
        (json['redeemed_at'] as String).isNotEmpty) {
      redeemed = DateTime.tryParse(json['redeemed_at']);
    }

    DateTime? expired;
    if (json['expired_at'] != null &&
        (json['expired_at'] as String).isNotEmpty) {
      expired = DateTime.tryParse(json['expired_at']);
    }

    return OrderPoints(
      orderName: json['display_id'] ?? '',
      pointsEarned: json['points_earned'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: expires,
      redeemedAt: redeemed,
      expiredAt: expired,
    );
  }
}
