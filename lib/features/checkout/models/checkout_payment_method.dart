import 'package:elkawther/core/services/dio_service.dart';
import 'package:flutter/material.dart';

class CheckoutPaymentMethod {
  const CheckoutPaymentMethod({
    required this.code,
    required this.type,
    required this.name,
    required this.requiresReceipt,
    this.accountName,
    this.accountNumber,
    this.instructions,
  });

  final String code;
  final String type;
  final String name;
  final bool requiresReceipt;
  final String? accountName;
  final String? accountNumber;
  final String? instructions;

  IconData get icon {
    final key = '$code $type'.toLowerCase();
    if (key.contains('cash')) return Icons.payments_rounded;
    if (key.contains('zain')) return Icons.account_balance_wallet_rounded;
    if (key.contains('card') || key.contains('qi')) {
      return Icons.credit_card_rounded;
    }
    return Icons.account_balance_rounded;
  }

  factory CheckoutPaymentMethod.fromJson(Map<String, dynamic> json) {
    String? text(dynamic value) {
      final raw = value?.toString().trim() ?? '';
      if (raw.isEmpty || raw == 'null') return null;
      return raw;
    }

    final receipt = json['requires_receipt'];
    return CheckoutPaymentMethod(
      code: text(json['code'] ?? json['id']) ?? '',
      type: text(json['type']) ?? '',
      name: text(json['name'] ?? json['title']) ?? '',
      requiresReceipt: receipt == true || receipt == 1 || receipt == '1' || receipt == 'true',
      accountName: text(json['account_name']),
      accountNumber: text(json['account_number']),
      instructions: text(json['instructions']),
    );
  }
}

Future<List<CheckoutPaymentMethod>> fetchCheckoutPaymentMethods() async {
  final response = await DioService.dio.get('/api/v1/user/payment-methods');
  final raw = response.data;
  final list = raw is Map && raw['data'] is List
      ? raw['data'] as List
      : raw is List
      ? raw
      : const [];
  return list
      .whereType<Map>()
      .map((item) => CheckoutPaymentMethod.fromJson(Map<String, dynamic>.from(item)))
      .where((method) => method.code.isNotEmpty)
      .toList();
}
