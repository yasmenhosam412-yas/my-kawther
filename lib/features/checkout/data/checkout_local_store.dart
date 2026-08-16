import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:flutter/foundation.dart';

class CheckoutLocalStore extends ChangeNotifier {
  CheckoutLocalStore._();
  static final CheckoutLocalStore instance = CheckoutLocalStore._();

  AddressModel? selected;
  int _nextId = 4;

  final List<AddressModel> addresses = [
    AddressModel(
      id: 1,
      address: 'شارع التحرير، الدقي، عمارة 12',
      city: 'القاهرة',
      apartment: '4',
      landmark: 'قرب جامعة القاهرة',
      type: 'home',
      isDefault: true,
      isPharmacy: false,
    ),
    AddressModel(
      id: 2,
      address: 'مدينة نصر، مجمع الأعمال، الطابق 3',
      city: 'القاهرة',
      apartment: 'مكتب 12',
      landmark: 'خلف سيتي ستارز',
      type: 'work',
      isDefault: false,
      isPharmacy: false,
    ),
    AddressModel(
      id: 3,
      address: 'صيدلية الكوثر - المعادي',
      city: 'القاهرة',
      landmark: 'https://maps.google.com/?q=Cairo',
      type: 'pharmacy',
      isDefault: false,
      isPharmacy: true,
    ),
  ];

  static const cities = ['القاهرة', 'الجيزة', 'الإسكندرية', 'المنصورة', 'أسيوط'];

  AddressModel get current =>
      selected ??
      addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first);

  double deliveryFeeFor(AddressModel address) {
    if (address.isPharmacy == true) return 0;
    if ((address.type ?? '').toLowerCase() == 'work') return 5;
    return 3;
  }

  double deliveryFeeForType(String type, {bool isPharmacy = false}) {
    if (isPharmacy) return 0;
    if (type.toLowerCase() == 'work') return 5;
    return 3;
  }

  int nextId() => _nextId++;

  void select(AddressModel address) {
    selected = address;
    notifyListeners();
  }

  void setDefault(int id) {
    for (var i = 0; i < addresses.length; i++) {
      addresses[i] = addresses[i].copyWith(isDefault: addresses[i].id == id);
    }
    selected = addresses.firstWhere((a) => a.id == id, orElse: () => current);
    notifyListeners();
  }

  void add(AddressModel address) {
    if (address.isDefault) {
      for (var i = 0; i < addresses.length; i++) {
        addresses[i] = addresses[i].copyWith(isDefault: false);
      }
    }
    addresses.add(address);
    notifyListeners();
  }

  void update(AddressModel address) {
    final index = addresses.indexWhere((item) => item.id == address.id);
    if (index < 0) return;
    if (address.isDefault) {
      for (var i = 0; i < addresses.length; i++) {
        addresses[i] = addresses[i].copyWith(isDefault: false);
      }
    }
    addresses[index] = address;
    if (selected?.id == address.id) selected = address;
    notifyListeners();
  }

  void remove(int id) {
    addresses.removeWhere((item) => item.id == id);
    if (selected?.id == id) selected = null;
    if (addresses.isNotEmpty && !addresses.any((item) => item.isDefault)) {
      addresses[0] = addresses[0].copyWith(isDefault: true);
    }
    notifyListeners();
  }

  static const zainNumber = '01012345678';
  static const qiCard = '1234 5678 9012';
  static const promoCode = 'ELKAWTHER';
  static const promoPercent = 0.15;
}
