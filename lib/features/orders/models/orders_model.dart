class OrdersModel {
  final bool success;
  final OrdersData data;

  OrdersModel({required this.success, required this.data});

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    if (rawData is Map) {
      return OrdersModel(
        success: json['success'] ?? false,
        data: OrdersData.fromJson(Map<String, dynamic>.from(rawData)),
      );
    }
    if (json.containsKey('pending') || json.containsKey('completed')) {
      return OrdersModel(success: true, data: OrdersData.fromJson(json));
    }
    return OrdersModel(success: json['success'] ?? false, data: OrdersData.empty());
  }
}

class OrdersData {
  final List<Order> pending;
  final List<Order> completed;
  final List<Order> canceled;
  final List<Order> confirmed;
  final List<Order> onDelivery;

  OrdersData({
    required this.pending,
    required this.completed,
    required this.canceled,
    required this.confirmed,
    required this.onDelivery,
  });

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    return OrdersData(
      pending:
          (json['pending'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      completed:
          (json['completed'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      canceled:
          (json['canceled'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      confirmed:
          (json['confirmed'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      onDelivery:
          (json['on_delivery'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }

  factory OrdersData.empty() {
    return OrdersData(
      pending: [],
      completed: [],
      canceled: [],
      confirmed: [],
      onDelivery: [],
    );
  }
}

class Order {
  final int orderId;
  final String status;
  final String totalPrice;
  final String? itemsCount;
  final String date;

  Order({
    required this.orderId,
    required this.status,
    required this.totalPrice,
    required this.itemsCount,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: int.tryParse('${json['order_id'] ?? json['id'] ?? 0}') ?? 0,
      status: json['status'] ?? '',
      totalPrice: (json['total_price'] ?? json['total'] ?? '0').toString(),
      itemsCount: json['items_count']?.toString(),
      date: (json['date'] ?? json['created_at'] ?? '').toString(),
    );
  }
}
