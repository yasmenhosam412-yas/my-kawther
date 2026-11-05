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
    final address = json['address'];
    return OrderDetailsModel(
      success: json['success'] == true || json['success'] == 1,
      orderId: _asInt(json['order_id'] ?? json['id']),
      status: _asText(json['status']),
      statusMeaning: _asText(json['status_meaning']),
      paymentMethod: _asText(json['payment_method']),
      deliveryFee: _asText(json['delivery_fee'], '0.00'),
      totalPrice: _asText(json['total_price'] ?? json['total'], '0.00'),
      pointsEarned: _asInt(json['points_earned']),
      giftDescription: json['gift_description']?.toString(),
      address: Address.fromJson(
        address is Map ? Map<String, dynamic>.from(address) : <String, dynamic>{},
      ),
      products:
          (json['products'] as List? ?? [])
              .whereType<Map>()
              .map(
                (item) =>
                    OrderProduct.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList(),
      createdAt: _asText(json['created_at']),
      lastUpdate: _asText(json['last_update'] ?? json['updated_at']),
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
      city: _asText(json['city'], '-'),
      street: _asText(json['street'], '-'),
      building: _asText(json['building'], '-'),
      apartment: _asText(json['apartment'], '-'),
      landmark: _asText(json['landmark'], '-'),
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
    final nested = json['product'];
    final product =
        nested is Map ? Map<String, dynamic>.from(nested) : <String, dynamic>{};
    final image = product['image_url'] ?? product['image'] ?? json['image'];
    return OrderProduct(
      productId: _asInt(product['id'] ?? json['product_id'] ?? json['id']),
      name: _asText(product['name'] ?? json['name']),
      image: image?.toString(),
      quantity: _asInt(json['quantity']),
      originalPrice: _asText(json['original_price'], '0.00'),
      priceAtTime: _asText(json['price_at_time'] ?? json['price'], '0.00'),
      totalPrice: _asText(json['total_price'] ?? json['total'], '0.00'),
      size: _asText(json['size']),
    );
  }
}

String _asText(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final text = value.toString();
  return text.isEmpty ? fallback : text;
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
