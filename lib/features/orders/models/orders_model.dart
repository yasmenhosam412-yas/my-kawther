class OrdersModel {
  final bool success;
  final OrdersData data;

  OrdersModel({required this.success, required this.data});

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return OrdersModel(
      success: json['success'] ?? false,
      data:
          rawData is Map<String, dynamic>
              ? OrdersData.fromJson(rawData)
              : OrdersData.empty(),
    );
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
              ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      completed:
          (json['completed'] as List<dynamic>?)
              ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      canceled:
          (json['canceled'] as List<dynamic>?)
              ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      confirmed:
          (json['confirmed'] as List<dynamic>?)
              ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      onDelivery:
          (json['on_delivery'] as List<dynamic>?)
              ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
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
      orderId: json['order_id'] ?? 0,
      status: json['status'] ?? '',
      totalPrice: json['total_price'] ?? '0',
      itemsCount: json['items_count']?.toString(),
      date: json['date'] ?? '',
    );
  }
}
