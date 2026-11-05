class AppliedPromotion {
  final String name;
  final String type;
  final double discount;
  final int rewardQuantity;

  const AppliedPromotion({
    required this.name,
    required this.type,
    required this.discount,
    required this.rewardQuantity,
  });

  factory AppliedPromotion.fromJson(Map<String, dynamic> json) {
    return AppliedPromotion(
      name: (json['name'] ?? json['code'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      discount: _asDouble(json['discount']),
      rewardQuantity: _asInt(json['reward_quantity']),
    );
  }
}

class OrderModel {
  final int orderId;
  final double totalPrice;
  final int pointsEarned;
  final String? giftDescription;
  final String message;
  final double subtotal;
  final double deliveryFee;
  final double totalSavings;
  final double pointsDiscount;
  final int pointsRedeemed;
  final String currency;
  final String paymentStatus;
  final List<String> gifts;
  final List<AppliedPromotion> appliedPromotions;

  OrderModel({
    required this.orderId,
    required this.totalPrice,
    required this.pointsEarned,
    this.giftDescription,
    required this.message,
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.totalSavings = 0,
    this.pointsDiscount = 0,
    this.pointsRedeemed = 0,
    this.currency = '',
    this.paymentStatus = '',
    this.gifts = const [],
    this.appliedPromotions = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final gift = json['gift_description'];
    return OrderModel(
      orderId: _asInt(json['order_id'] ?? json['id']),
      totalPrice: _asDouble(json['total_price']),
      pointsEarned: _asInt(json['points_earned']),
      giftDescription: gift == null || gift.toString().trim().isEmpty
          ? null
          : gift.toString(),
      message: (json['message'] ?? '').toString(),
      subtotal: _asDouble(json['subtotal']),
      deliveryFee: _asDouble(json['delivery_fee']),
      totalSavings: _asDouble(json['total_savings']),
      pointsDiscount: _asDouble(json['points_discount']),
      pointsRedeemed: _asInt(json['points_redeemed']),
      currency: (json['currency'] ?? '').toString(),
      paymentStatus: (json['payment_status'] ?? '').toString(),
      gifts: _gifts(json['gifts']),
      appliedPromotions: (json['applied_promotions'] as List? ?? [])
          .whereType<Map>()
          .map(
            (item) => AppliedPromotion.fromJson(Map<String, dynamic>.from(item)),
          )
          .where((item) => item.name.isNotEmpty || item.discount > 0)
          .toList(),
    );
  }
}

List<String> _gifts(dynamic raw) {
  if (raw is! List) return const [];
  return raw
      .map((item) {
        if (item is Map) {
          return (item['name'] ?? item['title'] ?? item['description'] ?? '')
              .toString();
        }
        return item?.toString() ?? '';
      })
      .where((item) => item.trim().isNotEmpty && item != 'null')
      .toList();
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
