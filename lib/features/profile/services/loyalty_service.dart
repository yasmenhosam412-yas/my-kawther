import 'package:dio/dio.dart';
import 'package:elkawther/core/services/dio_service.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';

class LoyaltyAccount {
  final int balance;
  final String rules;
  final bool redeemEnabled;
  final int minRedeemPoints;
  final int maxRedeemPoints;
  final double pointValue;

  const LoyaltyAccount({
    required this.balance,
    required this.rules,
    this.redeemEnabled = true,
    this.minRedeemPoints = 0,
    this.maxRedeemPoints = 0,
    this.pointValue = 0,
  });

  factory LoyaltyAccount.fromJson(dynamic raw) {
    final json = _map(raw);
    final source = json['data'] is Map ? _map(json['data']) : json;
    final settings = _settings(source);
    final enabled = settings['redeem_enabled'] ??
        settings['points_redeem_enabled'] ??
        settings['can_redeem_points'] ??
        source['redeem_enabled'];
    return LoyaltyAccount(
      balance: _asInt(
        source['balance'] ??
            source['points'] ??
            source['available_points'] ??
            source['valid_points'],
      ),
      rules: (source['rules'] ??
              settings['rules'] ??
              source['description'] ??
              '')
          .toString(),
      redeemEnabled: enabled == null || enabled == true || enabled == 1,
      minRedeemPoints: _asInt(
        settings['min_redeem_points'] ??
            settings['minimum_points'] ??
            settings['min_points'],
      ),
      maxRedeemPoints: _asInt(
        settings['max_redeem_points'] ??
            settings['maximum_points'] ??
            settings['max_points'],
      ),
      pointValue: _asDouble(
        settings['point_value'] ??
            settings['currency_per_point'] ??
            settings['redeem_rate'],
      ),
    );
  }
}

Map<String, dynamic> _settings(Map<String, dynamic> source) {
  for (final key in ['settings', 'loyalty_settings']) {
    final value = source[key];
    if (value is Map) return Map<String, dynamic>.from(value);
  }
  return source;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

class LoyaltyReward {
  final int id;
  final String name;
  final int points;
  final String description;

  const LoyaltyReward({
    required this.id,
    required this.name,
    required this.points,
    required this.description,
  });

  factory LoyaltyReward.fromJson(Map<String, dynamic> json) {
    return LoyaltyReward(
      id: _asInt(json['id']),
      name: (json['name'] ?? json['title'] ?? '').toString(),
      points: _asInt(json['points'] ?? json['cost'] ?? json['points_cost']),
      description: (json['description'] ?? '').toString(),
    );
  }
}

class LoyaltyService {
  final Dio _dio = DioService.dio;
  final SecureStorageHelper storageHelper = SecureStorageHelper();

  Future<LoyaltyAccount> account() async {
    final response = await _dio.get(
      '/api/user/loyalty',
      options: await _options(),
    );
    return LoyaltyAccount.fromJson(response.data);
  }

  Future<List<LoyaltyReward>> rewards() async {
    final response = await _dio.get(
      '/api/user/loyalty/rewards',
      options: await _options(),
    );
    return _rewardsFrom(response.data);
  }

  Future<LoyaltyReward> reward(int id) async {
    final response = await _dio.get(
      '/api/user/loyalty/rewards/$id',
      options: await _options(),
    );
    final json = _map(response.data);
    final source = json['data'] is Map ? _map(json['data']) : json;
    return LoyaltyReward.fromJson(source);
  }

  Future<String> redeemReward(int id, {int quantity = 1}) async {
    final response = await _dio.post(
      '/api/user/loyalty/rewards/$id/redeem',
      data: {'quantity': quantity},
      options: await _options(
        extra: {
          'Idempotency-Key':
              'reward-$id-${DateTime.now().microsecondsSinceEpoch}',
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = response.data;
    if (data is Map && data['message'] != null) return data['message'].toString();
    return '';
  }

  Future<List<Map<String, dynamic>>> history({
    String? type,
    String? from,
    String? to,
    int perPage = 20,
  }) async {
    final response = await _dio.get(
      '/api/user/loyalty/history',
      queryParameters: {
        if (type != null && type.isNotEmpty) 'type': type,
        if (from != null && from.isNotEmpty) 'from': from,
        if (to != null && to.isNotEmpty) 'to': to,
        'per_page': perPage,
      },
      options: await _options(),
    );
    return _recordList(response.data);
  }

  Future<List<Map<String, dynamic>>> expiring({int days = 7}) async {
    final response = await _dio.get(
      '/api/user/loyalty/expiring',
      queryParameters: {'days': days},
      options: await _options(),
    );
    return _recordList(response.data);
  }

  Future<List<Map<String, dynamic>>> redemptions({String? status}) async {
    final response = await _dio.get(
      '/api/user/loyalty/redemptions',
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status': status,
      },
      options: await _options(),
    );
    return _recordList(response.data);
  }

  Future<Map<String, dynamic>> redemption(int id) async {
    final response = await _dio.get(
      '/api/user/loyalty/redemptions/$id',
      options: await _options(),
    );
    return _map(response.data);
  }

  Future<Options> _options({Map<String, String>? extra}) async {
    final token = await storageHelper.safeRead('token');
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        ...?extra,
      },
    );
  }
}

List<LoyaltyReward> _rewardsFrom(dynamic raw) {
  final list = _list(raw);
  return list
      .whereType<Map>()
      .map((item) => LoyaltyReward.fromJson(Map<String, dynamic>.from(item)))
      .where((reward) => reward.id != 0)
      .toList();
}

List<Map<String, dynamic>> _recordList(dynamic raw) {
  return _list(raw)
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

List<dynamic> _list(dynamic raw) {
  if (raw is List) return raw;
  if (raw is Map) {
    for (final key in ['data', 'rewards', 'history', 'redemptions', 'items']) {
      final value = raw[key];
      if (value is List) return value;
      if (value is Map && value['data'] is List) return value['data'] as List;
    }
  }
  return const [];
}

Map<String, dynamic> _map(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return {};
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.round();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
