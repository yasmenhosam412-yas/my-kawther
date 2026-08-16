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

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    bool parseIsDefault(dynamic val) {
      if (val == null) return false;
      if (val is bool) return val;
      if (val is int) return val == 1;
      if (val is String) return val.toLowerCase() == 'true' || val == '1';
      return false;
    }

    return AddressModel(
      id: json['id'],
      address: json['address'],
      governorate: json['governorate'],
      city: json['city'],
      street: json['street'],
      building: json['building'],
      apartment: json['apartment'],
      landmark: json['landmark'],
      type: json['type'],
      isDefault: parseIsDefault(json['is_default']),
      isPharmacy: json['is_pharmacy'] ?? false,
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
