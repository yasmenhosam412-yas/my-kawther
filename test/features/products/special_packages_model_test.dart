import 'package:elkawther/features/products/models/special_packages_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses percentage and fixed discount sections separately', () {
    final model = SpecialPackagesModel.fromJson({
      'status': 'success',
      'data': {
        'top_percent_discount': {
          'discount_value': 10,
          'products': [],
          'total': 0,
        },
        'top_fixed_discount': {
          'discount_value': 25,
          'products': [
            {
              'id': 1,
              'name': 'Cream',
              'price_before_discount': 560,
              'price_after_discount': 535,
              'discount_type': 'fixed',
              'available_sizes': [],
            },
          ],
          'total': 1,
        },
      },
      'count': 1,
    });

    expect(model.topPercentDiscount?.discountValue, 10);
    expect(model.topPercentDiscount?.products, isEmpty);
    expect(model.topFixedDiscount?.discountValue, 25);
    expect(model.topFixedDiscount?.products, hasLength(1));
    expect(model.topFixedDiscount?.products.single.discountType, 'fixed');
    expect(model.topFixedDiscount?.products.single.sectionDiscount, 25);
    expect(
      model.topFixedDiscount?.products.single.priceBeforeDiscountDouble,
      560,
    );
    expect(model.topFixedDiscount?.products.single.priceAfterDiscount, 535);
  });
}
