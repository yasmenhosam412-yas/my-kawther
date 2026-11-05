class DeliveryPrice {
  final int id;
  final String governorate;
  final String price;

  DeliveryPrice({
    required this.id,
    required this.governorate,
    required this.price,
  });

  factory DeliveryPrice.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return DeliveryPrice(
      id: id is int ? id : int.tryParse('${id ?? 0}') ?? 0,
      governorate: (json['governorate'] ?? json['city'] ?? '').toString(),
      price: (json['price'] ?? json['delivery_price'] ?? json['delivery_fee'] ?? '0')
          .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'governorate': governorate, 'price': price};
  }
}

class DeliveryPricesResponse {
  final bool status;
  final String message;
  final List<DeliveryPrice> data;

  DeliveryPricesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DeliveryPricesResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryPricesResponse(
      status: json['status'],
      message: json['message'],
      data: List<DeliveryPrice>.from(
        json['data'].map((item) => DeliveryPrice.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
