class AddressModel {
  final int? id;
  final String? address;
  final String? governorate;
  final String? city;
  final String? street;
  final String? building;
  final String? apartment;
  final String? landmark;
  final String? type;
  final bool isDefault;
  final bool? isPharmacy;

  AddressModel({
    this.id,
    this.address,
    this.governorate,
    this.city,
    this.street,
    this.building,
    this.apartment,
    this.landmark,
    this.type,
    required this.isDefault,
    this.isPharmacy,
  });

  bool get isPickupFromPharmacy =>
      isPharmacy == true || type?.trim().toLowerCase() == 'pharmacy';

  int? get checkoutAddressId => isPickupFromPharmacy ? -1 : id;

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    int? parseId(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '');
    }

    String? parseString(dynamic value) => value?.toString();

    bool parseIsDefault(dynamic val) {
      if (val == null) return false;
      if (val is bool) return val;
      if (val is int) return val == 1;
      if (val is String) return val.toLowerCase() == 'true' || val == '1';
      return false;
    }

    return AddressModel(
      id: parseId(json['id']),
      address: parseString(json['address']),
      governorate: parseString(json['governorate']),
      city: parseString(json['city'] ?? json['governorate']),
      street: parseString(json['street']),
      building: parseString(json['building']),
      apartment: parseString(json['apartment']),
      landmark: parseString(json['landmark']),
      type: parseString(json['type']),
      isDefault: parseIsDefault(json['is_default'] ?? json['default']),
      isPharmacy:
          json['is_pharmacy'] is bool
              ? json['is_pharmacy'] as bool
              : parseIsDefault(json['is_pharmacy']),
    );
  }

  // Add this copyWith method:
  AddressModel copyWith({
    int? id,
    String? address,
    String? governorate,
    String? city,
    String? street,
    String? building,
    String? apartment,
    String? landmark,
    String? type,
    bool? isDefault,
    bool? isPharmacy,
  }) {
    return AddressModel(
      id: id ?? this.id,
      address: address ?? this.address,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      street: street ?? this.street,
      building: building ?? this.building,
      apartment: apartment ?? this.apartment,
      landmark: landmark ?? this.landmark,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      isPharmacy: isPharmacy ?? this.isPharmacy,
    );
  }
}

//---------------------------------------

class AddNewAddress {
  final String address;
  final String governorate;
  final String city;
  final String street;
  final String building;
  final String apartment;
  final String landmark;
  final String type;
  final bool isDefault;
  final int userId;
  final int id;

  AddNewAddress({
    required this.address,
    required this.governorate,
    required this.city,
    required this.street,
    required this.building,
    required this.apartment,
    required this.landmark,
    required this.type,
    required this.isDefault,
    required this.userId,
    required this.id,
  });

  factory AddNewAddress.fromJson(Map<String, dynamic> json) {
    return AddNewAddress(
      address: json['address'] ?? '',
      governorate: json['governorate'] ?? '',
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      building: json['building'] ?? '',
      apartment: json['apartment'] ?? '',
      landmark: json['landmark'] ?? '',
      type: json['type'] ?? '',
      isDefault: json['is_default'] ?? false,
      userId: json['user_id'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'governorate': governorate,
      'city': city,
      'street': street,
      'building': building,
      'apartment': apartment,
      'landmark': landmark,
      'type': type,
      'is_default': isDefault,
      'user_id': userId,
      'id': id,
    };
  }
}

//----------------------------------
