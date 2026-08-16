import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:elkawther/features/orders/models/orders_model.dart';
import 'package:elkawther/features/orders/models/track_order.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:flutter/foundation.dart';

class OrdersLocalStore extends ChangeNotifier {
  OrdersLocalStore._() {
    _seed();
  }

  static final OrdersLocalStore instance = OrdersLocalStore._();

  final List<Order> _orders = [];
  final Map<int, OrderDetailsModel> _details = {};
  int _nextId = 1100;

  List<Order> get all => List.unmodifiable(_orders);

  List<Order> current() => _orders
      .where(
        (order) =>
            order.status == 'pending' ||
            order.status == 'confirmed' ||
            order.status == 'on_delivery',
      )
      .toList();

  List<Order> past() =>
      _orders.where((order) => order.status == 'completed').toList();

  List<Order> canceled() =>
      _orders.where((order) => order.status == 'canceled').toList();

  OrderDetailsModel? detailsFor(int orderId) => _details[orderId];

  TrackOrder trackFor(int orderId) {
    final details = _details[orderId];
    return TrackOrder(
      success: true,
      orderId: orderId,
      status: details?.status ?? 'pending',
      statusMeaning: details?.statusMeaning ?? '',
      lastUpdate: details?.lastUpdate ?? DateTime.now().toIso8601String(),
    );
  }

  void addFromCheckout({
    required List<HomeDemoProduct> items,
    required AddressModel address,
    required String paymentMethod,
    required String total,
    required String deliveryFee,
    String? gift,
  }) {
    final orderId = _nextId++;
    final products = items
        .map((item) => _productFromDemo(item, qty: 1))
        .toList();
    final now = DateTime.now();
    final isPharmacy = address.isPharmacy == true;

    _orders.insert(
      0,
      Order(
        orderId: orderId,
        status: 'pending',
        totalPrice: total,
        itemsCount: '${items.length}',
        date: now.toIso8601String(),
      ),
    );
    _details[orderId] = OrderDetailsModel(
      success: true,
      orderId: orderId,
      status: 'pending',
      statusMeaning: 'pending',
      paymentMethod: paymentMethod,
      deliveryFee: deliveryFee,
      totalPrice: total,
      pointsEarned: 80,
      giftDescription: gift,
      address: isPharmacy
          ? Address(
              city: '-',
              street: '-',
              building: '-',
              apartment: '-',
              landmark: '-',
            )
          : Address(
              city: address.city ?? 'القاهرة',
              street: address.address ?? '',
              building: '',
              apartment: address.apartment ?? '',
              landmark: address.landmark ?? '',
            ),
      products: products,
      createdAt: now.toIso8601String(),
      lastUpdate: now.toIso8601String(),
    );
    notifyListeners();
  }

  void _seed() {
    final home = Address(
      city: 'القاهرة',
      street: 'شارع التحرير، الدقي، عمارة 12',
      building: '12',
      apartment: '4',
      landmark: 'قرب جامعة القاهرة',
    );
    final pharmacy = Address(
      city: '-',
      street: '-',
      building: '-',
      apartment: '-',
      landmark: '-',
    );

    _add(
      id: 1042,
      status: 'pending',
      daysAgo: 0,
      payment: 'cash',
      delivery: '3',
      points: 80,
      gift: 'فيتامين C',
      address: home,
      products: [_product(4, qty: 2), _product(5)],
    );
    _add(
      id: 1038,
      status: 'confirmed',
      daysAgo: 1,
      payment: 'zaincash',
      delivery: '5',
      points: 50,
      address: home,
      products: [_product(7)],
    );
    _add(
      id: 1035,
      status: 'on_delivery',
      daysAgo: 2,
      payment: 'cash',
      delivery: '3',
      points: 40,
      address: home,
      products: [_product(6), _product(8)],
    );
    _add(
      id: 1031,
      status: 'completed',
      daysAgo: 12,
      payment: 'qicard',
      delivery: '3',
      points: 50,
      gift: 'كريم مرطب',
      address: home,
      products: [_product(4), _product(5, qty: 2), _product(9)],
    );
    _add(
      id: 1018,
      status: 'completed',
      daysAgo: 21,
      payment: 'cash',
      delivery: '0',
      points: 40,
      address: pharmacy,
      products: [_product(5)],
    );
    _add(
      id: 988,
      status: 'canceled',
      daysAgo: 40,
      payment: 'cash',
      delivery: '3',
      points: 0,
      address: home,
      products: [_product(6), _product(9)],
    );
  }

  void _add({
    required int id,
    required String status,
    required int daysAgo,
    required String payment,
    required String delivery,
    required int points,
    required Address address,
    required List<OrderProduct> products,
    String? gift,
  }) {
    final created = DateTime.now().subtract(Duration(days: daysAgo, hours: 3));
    final total = products.fold<double>(
      0,
      (sum, item) => sum + (double.tryParse(item.totalPrice) ?? 0),
    );
    final itemsCount = products.fold<int>(0, (sum, item) => sum + item.quantity);

    _orders.add(
      Order(
        orderId: id,
        status: status,
        totalPrice: total.toStringAsFixed(0),
        itemsCount: '$itemsCount',
        date: created.toIso8601String(),
      ),
    );
    _details[id] = OrderDetailsModel(
      success: true,
      orderId: id,
      status: status,
      statusMeaning: status,
      paymentMethod: payment,
      deliveryFee: delivery,
      totalPrice: (total + (double.tryParse(delivery) ?? 0)).toStringAsFixed(0),
      pointsEarned: points,
      giftDescription: gift,
      address: address,
      products: products,
      createdAt: created.toIso8601String(),
      lastUpdate: created.add(const Duration(hours: 5)).toIso8601String(),
    );
  }

  OrderProduct _product(int id, {int qty = 1}) {
    final product = HomeDemoData.allProducts.firstWhere((item) => item.id == id);
    return _productFromDemo(product, qty: qty);
  }

  OrderProduct _productFromDemo(HomeDemoProduct product, {int qty = 1}) {
    final total = product.price * qty;
    return OrderProduct(
      productId: product.id,
      name: product.nameAr,
      image: product.imageUrl,
      quantity: qty,
      originalPrice: product.price.toStringAsFixed(0),
      priceAtTime: product.price.toStringAsFixed(0),
      totalPrice: total.toStringAsFixed(0),
      size: '1',
    );
  }
}
