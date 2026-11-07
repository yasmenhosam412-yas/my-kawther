class AllReturns {
  final int id;
  final int orderId;
  final String reason;
  final String? note;
  final String status;
  final String refundAmount;
  final String? refundMethod;
  final String? address;
  final DateTime createdAt;
  final OrderReturned? order;

  AllReturns({
    required this.id,
    required this.orderId,
    required this.reason,
    this.note,
    required this.status,
    required this.refundAmount,
    this.refundMethod,
    this.address,
    required this.createdAt,
    this.order,
  });

  factory AllReturns.fromJson(Map<String, dynamic> json) {
    final order = json['order'];
    return AllReturns(
      id: _asInt(json['id']),
      orderId: _asInt(json['order_id']),
      reason: _asString(json['reason']),
      note: _nullable(json['note']),
      status: _asString(json['status']),
      refundAmount: _asString(json['refund_amount']),
      refundMethod: _nullable(json['refund_method']),
      address: _nullable(json['address']),
      createdAt: _asDate(json['created_at']),
      order: order is Map
          ? OrderReturned.fromJson(Map<String, dynamic>.from(order))
          : null,
    );
  }
}

class OrderReturned {
  final int id;
  final int userId;
  final int addressId;
  final String paymentMethod;
  final String? paymentImage;
  final String deliveryFee;
  final String totalPrice;
  final String? giftDescription;
  final int? giftRuleId;
  final int pointsEarned;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderReturned({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.paymentMethod,
    this.paymentImage,
    required this.deliveryFee,
    required this.totalPrice,
    this.giftDescription,
    this.giftRuleId,
    required this.pointsEarned,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderReturned.fromJson(Map<String, dynamic> json) {
    return OrderReturned(
      id: _asInt(json['id']),
      userId: _asInt(json['user_id']),
      addressId: _asInt(json['address_id'], fallback: -1),
      paymentMethod: _asString(json['payment_method']),
      paymentImage: _nullable(json['payment_image']),
      deliveryFee: _asString(json['delivery_fee']),
      totalPrice: _asString(json['total_price']),
      giftDescription: _nullable(json['gift_description']),
      giftRuleId: json['gift_rule_id'] == null ? null : _asInt(json['gift_rule_id']),
      pointsEarned: _asInt(json['points_earned']),
      status: _asString(json['status']),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }
}
//---------------------------------

class RefundedItem {
  final int id;
  final int userId;
  final int orderId;
  final String reason;
  final String? note;
  final String? refundAmount;
  final String? refundMethod;
  final String? address;
  final String? status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ShowOne order;
  final List<String> images;

  RefundedItem({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.reason,
    this.note,
    required this.refundAmount,
    required this.refundMethod,
    required this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.order,
    required this.images,
  });

  factory RefundedItem.fromJson(Map<String, dynamic> json) {
    final body = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    final order = body['order'];
    return RefundedItem(
      id: _asInt(body['id']),
      userId: _asInt(body['user_id']),
      orderId: _asInt(body['order_id']),
      reason: _asString(body['reason']),
      note: _nullable(body['note']),
      refundAmount: _nullable(body['refund_amount']),
      refundMethod: _nullable(body['refund_method']),
      address: _nullable(body['address']),
      status: _nullable(body['status']),
      createdAt: _asDate(body['created_at']),
      updatedAt: _asDate(body['updated_at']),
      order: order is Map
          ? ShowOne.fromJson(Map<String, dynamic>.from(order))
          : ShowOne.empty(),
      images: returnImageKeys(body['images']),
    );
  }
}

List<String> returnImageKeys(dynamic raw) {
  if (raw is! List) return const [];
  final keys = <String>[];
  for (final item in raw) {
    if (item is String && item.trim().isNotEmpty) {
      keys.add(item.trim());
    } else if (item is num) {
      keys.add(item.toString());
    } else if (item is Map) {
      final value = item['id'] ?? item['image'] ?? item['file'] ?? item['name'] ?? item['path'];
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) keys.add(text);
    }
  }
  return keys;
}

class ShowOne {
  final int id;
  final int userId;
  final int addressId;
  final String paymentMethod;
  final String? paymentImage;
  final String deliveryFee;
  final String totalPrice;
  final String? giftDescription;
  final int? giftRuleId;
  final int pointsEarned;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShowOne({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.paymentMethod,
    this.paymentImage,
    required this.deliveryFee,
    required this.totalPrice,
    this.giftDescription,
    this.giftRuleId,
    required this.pointsEarned,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShowOne.empty() {
    final now = DateTime.now();
    return ShowOne(
      id: 0,
      userId: 0,
      addressId: -1,
      paymentMethod: '',
      deliveryFee: '',
      totalPrice: '',
      pointsEarned: 0,
      status: '',
      createdAt: now,
      updatedAt: now,
    );
  }

  factory ShowOne.fromJson(Map<String, dynamic> json) {
    return ShowOne(
      id: _asInt(json['id']),
      userId: _asInt(json['user_id']),
      addressId: _asInt(json['address_id'], fallback: -1),
      paymentMethod: _asString(json['payment_method']),
      paymentImage: _nullable(json['payment_image']),
      deliveryFee: _asString(json['delivery_fee']),
      totalPrice: _asString(json['total_price']),
      giftDescription: _nullable(json['gift_description']),
      giftRuleId: json['gift_rule_id'] == null ? null : _asInt(json['gift_rule_id']),
      pointsEarned: _asInt(json['points_earned']),
      status: _asString(json['status']),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

String _asString(dynamic value) => value?.toString() ?? '';

String? _nullable(dynamic value) {
  final text = value?.toString().trim() ?? '';
  if (text.isEmpty || text == 'null') return null;
  return text;
}

DateTime _asDate(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
