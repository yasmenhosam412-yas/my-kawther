class OrderDetailsModel {
  final bool success;
  final int orderId;
  final String status;
  final String statusMeaning;
  final String paymentMethod;
  final String deliveryFee;
  final String totalPrice;
  final int pointsEarned;
  final String? giftDescription;
  final Address address;
  final List<OrderProduct> products;
  final String createdAt;
  final String lastUpdate;

  OrderDetailsModel({
    required this.success,
    required this.orderId,
    required this.status,
    required this.statusMeaning,
    required this.paymentMethod,
    required this.deliveryFee,
    required this.totalPrice,
    required this.pointsEarned,
    required this.giftDescription,
    required this.address,
    required this.products,
    required this.createdAt,
    required this.lastUpdate,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      success: json['success'] ?? false,
      orderId: json['order_id'] ?? 0,
      status: json['status'] ?? "",
      statusMeaning: json['status_meaning'] ?? "",
      paymentMethod: json['payment_method'] ?? "",
      deliveryFee: json['delivery_fee'] ?? "0.00",
      totalPrice: json['total_price'] ?? "0.00",
      pointsEarned:
          json['points_earned'] is int
              ? json['points_earned']
              : int.tryParse(json['points_earned'].toString()) ?? 0,
      giftDescription: json['gift_description'],
      address: Address.fromJson(json['address'] ?? {}),
      products:
          (json['products'] as List? ?? [])
              .map((e) => OrderProduct.fromJson(e))
              .toList(),
      createdAt: json['created_at'] ?? "",
      lastUpdate: json['last_update'] ?? "",
    );
  }
}

class Address {
  final String city;
  final String street;
  final String building;
  final String apartment;
  final String landmark;

  Address({
    required this.city,
    required this.street,
    required this.building,
    required this.apartment,
    required this.landmark,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] ?? "-",
      street: json['street'] ?? "-",
      building: json['building'] ?? "-",
      apartment: json['apartment'] ?? "-",
      landmark: json['landmark'] ?? "-",
    );
  }
}

class OrderProduct {
  final int productId;
  final String name;
  final String? image;
  final int quantity;
  final String originalPrice;
  final String priceAtTime;
  final String totalPrice;
  final String size;

  OrderProduct({
    required this.productId,
    required this.name,
    required this.image,
    required this.quantity,
    required this.originalPrice,
    required this.priceAtTime,
    required this.totalPrice,
    required this.size,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return OrderProduct(
      productId: product['id'] ?? 0,
      name: product['name'] ?? "",
      image: product['image_url'],
      quantity: json['quantity'] ?? 0,
      originalPrice: json['original_price'] ?? "0.00",
      priceAtTime: json['price_at_time'] ?? "0.00",
      totalPrice: json['total_price'] ?? "0.00",
      size: json['size'] ?? "",
    );
  }
}
