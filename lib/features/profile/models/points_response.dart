class PointsResponse {
  final int totalPoints;
  final List<OrderPoints> orders;

  PointsResponse({required this.totalPoints, required this.orders});

  factory PointsResponse.fromJson(Map<String, dynamic> json) {
    final ordersJson =
        json['orders'] as List<dynamic>? ??
        (json['data'] is List ? json['data'] as List<dynamic> : const []);
    final ordersList = ordersJson
        .whereType<Map>()
        .map((e) => OrderPoints.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final total = _asInt(
      json['valid_points_total'] ??
          json['consumed_points_total'] ??
          json['expired_points_total'] ??
          json['total'] ??
          json['balance'],
    );

    return PointsResponse(totalPoints: total, orders: ordersList);
  }
}

class OrderPoints {
  final int id;
  final String orderName;
  final int pointsEarned;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final DateTime? expiredAt;
  final DateTime? redeemedAt;

  OrderPoints({
    this.id = 0,
    required this.orderName,
    required this.pointsEarned,
    required this.createdAt,
    this.expiresAt,
    this.redeemedAt,
    this.expiredAt,
  });

  factory OrderPoints.fromJson(Map<String, dynamic> json) {
    return OrderPoints(
      id: _asInt(json['id']),
      orderName:
          (json['display_id'] ??
                  json['order_name'] ??
                  json['name'] ??
                  json['title'] ??
                  json['description'] ??
                  json['status'] ??
                  json['type'] ??
                  '')
              .toString(),
      pointsEarned: _asInt(json['points_earned'] ?? json['points'] ?? json['amount']),
      createdAt: _asDate(json['created_at']) ?? DateTime.now(),
      expiresAt: _asDate(json['expires_at']),
      redeemedAt: _asDate(json['redeemed_at']),
      expiredAt: _asDate(json['expired_at']),
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.round();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime? _asDate(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return DateTime.tryParse(text);
}
