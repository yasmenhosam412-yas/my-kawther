import 'package:elkawther/features/products/models/latest_products_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses discounted latest product prices from available sizes', () {
    final model = LatestProductsModel.fromJson({
      'data': [
        {
          'id': 7,
          'name': 'Discounted product',
          'final_price': 90,
          'discount_type': 'percent',
          'available_sizes': [
            {
              'id': 12,
              'original_price': 100,
              'price': 90,
            },
          ],
        },
      ],
    });

    final product = model.data!.single;
    final size = product.availableSizes!.single;

    expect(product.finalPrice, 90);
    expect(size.originalPrice, 100);
    expect(size.price, 90);
    expect(product.discountType, 'percent');
  });
}
