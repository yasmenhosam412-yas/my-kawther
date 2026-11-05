import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddressModel.isPickupFromPharmacy', () {
    test('recognizes pharmacy addresses from their type', () {
      final address = AddressModel.fromJson({
        'id': 12,
        'type': 'pharmacy',
        'is_default': false,
      });

      expect(address.isPickupFromPharmacy, isTrue);
      expect(address.checkoutAddressId, -1);
    });

    test('recognizes pharmacy addresses from the is_pharmacy flag', () {
      final address = AddressModel.fromJson({
        'id': 13,
        'type': 'home',
        'is_pharmacy': true,
        'is_default': false,
      });

      expect(address.isPickupFromPharmacy, isTrue);
      expect(address.checkoutAddressId, -1);
    });

    test('does not classify a regular address as pharmacy pickup', () {
      final address = AddressModel.fromJson({
        'id': 14,
        'type': 'home',
        'is_pharmacy': false,
        'is_default': true,
      });

      expect(address.isPickupFromPharmacy, isFalse);
      expect(address.checkoutAddressId, 14);
    });
  });
}
