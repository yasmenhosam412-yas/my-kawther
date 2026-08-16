import 'package:elkawther/features/categories/models/categories_model.dart';
import 'package:elkawther/features/orders/models/order_model.dart';

class ViewMoreProductsArgs {
  final String title;
  final String productType;

  ViewMoreProductsArgs({required this.title, required this.productType});
}

class BrandProductsArgs {
  final int id;
  final String name;

  BrandProductsArgs({required this.id, required this.name});
}

class HealthIssueProductsArgs {
  final int id;
  final String name;

  HealthIssueProductsArgs({required this.id, required this.name});
}

class CategoryProductsArgs {
  final int id;
  final String name;
  final String? from;
  final String? imageUrl;
  final List<Subcategory> subcategory;

  CategoryProductsArgs({
    required this.id,
    required this.name,
    this.from,
    this.imageUrl,
    required this.subcategory,
  });
}

class OrderDetailsArgs {
  final OrderModel order;

  OrderDetailsArgs({required this.order});
}
