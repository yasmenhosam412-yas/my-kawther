class SaleableModel {
  final int id;
  final String discountValue;
  final int isActive;
  final String? startsAt;
  final String? endsAt;

  SaleableModel({
    required this.id,
    required this.discountValue,
    required this.isActive,
    this.startsAt,
    this.endsAt,
  });

  factory SaleableModel.fromJson(Map<String, dynamic> json) {
    return SaleableModel(
      id: json['id'],
      discountValue: json['discount_value'],
      isActive: json['is_active'],
      startsAt: json['starts_at'],
      endsAt: json['ends_at'],
    );
  }
}
