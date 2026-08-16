class AllReturns {
  final int id;
  final int orderId;
  final String reason;
  final String status;
  final String refundAmount;
  final DateTime createdAt;
  final OrderReturned order;

  AllReturns({
    required this.id,
    required this.orderId,
    required this.reason,
    required this.status,
    required this.refundAmount,
    required this.createdAt,
    required this.order,
  });

  factory AllReturns.fromJson(Map<String, dynamic> json) {
    return AllReturns(
      id: json['id'],
      orderId: json['order_id'],
      reason: json['reason'],
      status: json['status'],
      refundAmount: json['refund_amount'],
      createdAt: DateTime.parse(json['created_at']),
      order: OrderReturned.fromJson(json['order']),
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
      id: json['id'],
      userId: json['user_id'],
      addressId: json['address_id'] ?? -1,
      paymentMethod: json['payment_method'],
      paymentImage: json['payment_image'],
      deliveryFee: json['delivery_fee'],
      totalPrice: json['total_price'],
      giftDescription: json['gift_description'],
      giftRuleId: json['gift_rule_id'],
      pointsEarned: json['points_earned'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
  final List<Map<String, dynamic>> images;

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
    return RefundedItem(
      id: json['id'],
      userId: json['user_id'],
      orderId: json['order_id'],
      reason: json['reason'],
      note: json['note'],
      refundAmount: json['refund_amount'],
      refundMethod: json['refund_method'],
      address: json['address'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      order: ShowOne.fromJson(json['order']),
      images: List<Map<String, dynamic>>.from(json['images'] ?? []),
    );
  }
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

  factory ShowOne.fromJson(Map<String, dynamic> json) {
    return ShowOne(
      id: json['id'],
      userId: json['user_id'],
      addressId: json['address_id'] ?? -1,
      paymentMethod: json['payment_method'],
      paymentImage: json['payment_image'],
      deliveryFee: json['delivery_fee'],
      totalPrice: json['total_price'],
      giftDescription: json['gift_description'],
      giftRuleId: json['gift_rule_id'],
      pointsEarned: json['points_earned'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
