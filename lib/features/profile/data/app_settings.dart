import 'package:elkawther/core/di/service_locator.dart';
import 'package:elkawther/features/checkout/data/checkout_local_store.dart';
import 'package:elkawther/features/profile/models/setting_response.dart';
import 'package:elkawther/features/profile/services/profile_services.dart';
import 'package:flutter/foundation.dart';

class AppSettings extends ChangeNotifier {
  AppSettings._();

  static final AppSettings instance = AppSettings._();

  BrandSettings? settings;

  Future<void> load() async {
    try {
      settings = await getIt<ProfileServices>().fetchBrandSettings();
      _applyPharmacyMap();
    } catch (error) {
      debugPrint('Settings load failed: $error');
    }
    notifyListeners();
  }

  String? get mapUrl => _http(settings?.mapLocationUrl);

  String? get whatsAppUrl {
    final digits = settings?.phoneNumber?.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits == null || digits.isEmpty) return null;
    return 'https://wa.me/$digits';
  }

  String? get facebook => _http(settings?.facebook);

  String? get instagram => _http(settings?.instagram);

  String? get tiktok => _http(settings?.tiktok);

  String? get youtube => _http(settings?.youtube);

  String? get zaincash {
    final value = settings?.zaincash?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String? get keyCard {
    final value = settings?.keyCard?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String? loyaltySummary(bool isAr) {
    final spend = settings?.spendX?.trim();
    final reward = settings?.getY?.trim();
    final days = settings?.pointsValidityDays;
    if ((spend == null || spend.isEmpty) &&
        (reward == null || reward.isEmpty) &&
        days == null) {
      return null;
    }
    final earn =
        spend != null &&
                spend.isNotEmpty &&
                reward != null &&
                reward.isNotEmpty
            ? (isAr
                ? 'كل $spend يمنحك $reward نقاط'
                : 'Every $spend earns $reward points')
            : null;
    final validity =
        days == null
            ? null
            : (isAr ? 'صلاحية النقاط $days يوماً' : 'Points stay valid for $days days');
    return [earn, validity].whereType<String>().join(isAr ? '، ' : '. ');
  }

  void _applyPharmacyMap() {
    final map = mapUrl;
    if (map == null) return;
    final store = CheckoutLocalStore.instance;
    for (var i = 0; i < store.addresses.length; i++) {
      final address = store.addresses[i];
      if (address.isPickupFromPharmacy) {
        store.addresses[i] = address.copyWith(landmark: map);
      }
    }
    store.notifyListeners();
  }

  String? _http(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return null;
    }
    return value;
  }
}
