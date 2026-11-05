import 'package:dio/dio.dart';
import 'package:elkawther/core/services/dio_service.dart';
import 'package:elkawther/features/health_services/data/health_local_calc.dart';
import 'package:elkawther/features/health_services/models/measures.dart';
import 'package:elkawther/features/health_services/models/month_response.dart';
import 'package:elkawther/features/health_services/models/monthly_period_calc_model.dart';
import 'package:elkawther/features/health_services/models/pregnancy_calc_model.dart';
import 'package:elkawther/features/health_services/models/vaccines.dart';
import 'package:elkawther/features/health_services/models/weight_body.dart';

/// Health API client.
///
/// Authorization is attached by [AuthenticatorInterceptor], and Accept /
/// Content-Type are already on the shared Dio instance. Reading the token
/// again here would hit secure storage on every call and could send
/// `Bearer null` when the session is empty.
class HealthService {
  final Dio _dio = DioService.dio;

  Future<List<Map<String, dynamic>>> getWeightHistory() async {
    final response = await _dio.get('/api/user/health/weight');
    return _records(response.data);
  }

  Future<WeightBody> getBodyWeightData({
    required double weight,
    required double height,
    required String unit,
  }) async {
    final response = await _dio.post(
      '/api/user/health/body-weight',
      data: {'weight': weight, 'height': height, 'unit': unit},
    );
    return WeightBody.fromJson(_modelMap(response.data, _isWeightBody));
  }

  Future<MonthlyPeriodCalc> getPeriodData({
    required String startDayOfCycle,
    required int cycleLength,
    required int periodLength,
  }) async {
    final local = _localPeriod(
      startDayOfCycle: startDayOfCycle,
      cycleLength: cycleLength,
      periodLength: periodLength,
    );
    try {
      final response = await _dio.post(
        '/api/user/health/ovulation',
        data: {
          'start_day_of_cycle': startDayOfCycle,
          'cycle_length': cycleLength,
          'period_length': periodLength,
        },
      );
      return _mergePeriod(_periodCalc(response.data), local);
    } on DioException catch (error) {
      if (_isOffline(error)) return local;
      rethrow;
    } on _HealthApiException {
      rethrow;
    } catch (_) {
      return local;
    }
  }

  Future<MonthResponse> currentPeriodData() async {
    final response = await _dio.get('/api/user/health/ovulation/current');
    final raw = response.data;
    if (raw is! Map) {
      throw const _HealthApiException('Unexpected server response');
    }

    final body = _asMap(raw);
    final embedded = _embeddedMessage(body);
    if (embedded != null) throw _HealthApiException(embedded);

    final calendar = _monthIfPresent(body) ?? _monthIfPresent(body['data']);
    if (calendar != null) return calendar;

    final period = MonthlyPeriodCalc.fromJson(body);
    final built = HealthLocalCalc.monthResponse(period);
    if (built != null && period.hasCycleDays) return built;

    throw _HealthApiException(_readableMessage(body));
  }

  Future<PregnancyCalcModel> getPreganacyCalcData({
    required String lastPeriodDate,
  }) async {
    final response = await _dio.post(
      '/api/user/health/calculatePregnancy',
      data: {'last_period_date': lastPeriodDate},
    );
    return PregnancyCalcModel.fromJson(
      _modelMap(response.data, _isPregnancyCalc),
    );
  }

  Future<PregnancyResultModel> getPreganacyCalcCurrentData() async {
    final response = await _dio.get('/api/user/health/CurrentPregnancyStage');
    return PregnancyResultModel.fromJson(
      _modelMap(response.data, _isPregnancyResult),
    );
  }

  Future<BloodMeasureModel> getBloodMesureData({
    required int systolic,
    required int diastolic,
    required String conditionType,
    required String measuredAt,
  }) async {
    final response = await _dio.post(
      '/api/user/health/blood-pressure',
      data: {
        'systolic': systolic,
        'diastolic': diastolic,
        'condition_type': conditionType,
        'measured_at': measuredAt,
      },
    );
    return _decode(
      response.data,
      BloodMeasureModel.fromJson,
      requiredKeys: const ['data'],
    );
  }

  Future<List<BloodPressureDataFetched>> getBloodMesureDataFetched() async {
    final response = await _dio.get('/api/user/health/blood-pressure');
    return _decodeList(response.data, BloodPressureDataFetched.fromJson);
  }

  Future<BloodSugarModel> getBloodSugarMesureData({
    required int value,
    required String conditionType,
    required String measuredAt,
  }) async {
    final response = await _dio.post(
      '/api/user/health/blood-sugar',
      data: {
        'value': value,
        'condition_type': conditionType,
        'measured_at': measuredAt,
      },
    );
    return _decode(
      response.data,
      BloodSugarModel.fromJson,
      requiredKeys: const ['data'],
    );
  }

  Future<List<BloodSugarDataFetched>> fetchBloodSugarMeasureData() async {
    final response = await _dio.get('/api/user/health/blood-sugar');
    return _decodeList(response.data, BloodSugarDataFetched.fromJson);
  }

  Future<VaccinesModel> getVaccinesData({
    required String babyName,
    required String babyGender,
    required String babyBirth,
  }) async {
    final response = await _dio.post(
      '/api/user/health/child',
      data: {
        'child_name': babyName,
        'gender': babyGender,
        'birth_date': babyBirth,
      },
    );
    return _decode(
      response.data,
      VaccinesModel.fromJson,
      requiredKeys: const ['child'],
    );
  }

  Future<ChildrenResponse> getVaccinesFullDataChildren() async {
    final response = await _dio.get('/api/user/health/child/vaccines');
    return _decode(
      response.data,
      ChildrenResponse.fromJson,
      requiredKeys: const ['children'],
    );
  }

  Future<CompletedVaccines> updateVaccinesData({
    required int vacID,
    bool isCompleted = true,
  }) async {
    final response = await _dio.patch(
      '/api/user/health/vaccines/$vacID/complete',
      data: {'is_completed': isCompleted},
    );
    return _decode(
      response.data,
      CompletedVaccines.fromJson,
      requiredKeys: const ['vaccine'],
    );
  }

  Future<String> deleteChild(int childId) async {
    final response = await _dio.delete('/api/user/health/child/$childId');
    final body = response.data;
    if (body is! Map) return '';

    final embedded = _embeddedMessage(body);
    if (embedded != null) throw _HealthApiException(embedded);

    final message = body['message'];
    return message?.toString() ?? '';
  }
}

class _HealthApiException implements Exception {
  final String message;

  const _HealthApiException(this.message);

  @override
  String toString() => message;
}

typedef _JsonMatch = bool Function(Map<String, dynamic> json);

MonthlyPeriodCalc _localPeriod({
  required String startDayOfCycle,
  required int cycleLength,
  required int periodLength,
}) {
  final start = HealthLocalCalc.parseDate(startDayOfCycle) ?? DateTime.now();
  return HealthLocalCalc.period(
    startDay: start,
    cycleLength: cycleLength,
    periodLength: periodLength,
  );
}

MonthlyPeriodCalc _periodCalc(dynamic raw) {
  if (raw is! Map) {
    throw const _HealthApiException('Unexpected server response');
  }
  final body = _asMap(raw);
  final embedded = _embeddedMessage(body);
  if (embedded != null) throw _HealthApiException(embedded);
  return MonthlyPeriodCalc.fromJson(body);
}

MonthlyPeriodCalc _mergePeriod(
  MonthlyPeriodCalc remote,
  MonthlyPeriodCalc local,
) {
  if (remote.hasCycleDays) return remote;
  return MonthlyPeriodCalc(
    message: remote.message,
    data: PeriodData(
      period: local.data.period,
      ovulationDate:
          remote.data.ovulationDate.isNotEmpty
              ? remote.data.ovulationDate
              : local.data.ovulationDate,
      fertileStart:
          remote.data.fertileStart.isNotEmpty
              ? remote.data.fertileStart
              : local.data.fertileStart,
      fertileEnd:
          remote.data.fertileEnd.isNotEmpty
              ? remote.data.fertileEnd
              : local.data.fertileEnd,
      days: local.data.days,
    ),
  );
}

MonthResponse? _monthIfPresent(dynamic raw) {
  if (raw is! Map) return null;
  final map = _asMap(raw);
  if (map['months'] is! Map) return null;
  try {
    final parsed = MonthResponse.fromJson(map);
    if (parsed.months.isEmpty) return null;
    return parsed;
  } catch (_) {
    return null;
  }
}

bool _isOffline(DioException error) {
  return error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.connectionError;
}

T _decode<T>(
  dynamic raw,
  T Function(Map<String, dynamic> json) fromJson, {
  List<String> requiredKeys = const [],
}) {
  final body = _asMap(raw);
  final embedded = _embeddedMessage(body);
  if (embedded != null) throw _HealthApiException(embedded);

  for (final key in requiredKeys) {
    if (body[key] == null) throw _HealthApiException(_readableMessage(body));
  }
  return fromJson(body);
}

Map<String, dynamic> _modelMap(dynamic raw, _JsonMatch matches) {
  final body = _asMap(raw);
  final embedded = _embeddedMessage(body);
  if (embedded != null) throw _HealthApiException(embedded);
  if (matches(body)) return body;

  final data = body['data'];
  if (data is Map) {
    final map = _asMap(data);
    if (matches(map)) return map;
    final nested = _matchingResult(map, matches);
    if (nested != null) return nested;
  }

  final nested = _matchingResult(body, matches);
  if (nested != null) return nested;

  throw _HealthApiException(_readableMessage(body));
}

Map<String, dynamic>? _matchingResult(
  Map<String, dynamic> json,
  _JsonMatch matches,
) {
  final result = json['result'];
  if (result is! Map) return null;
  final map = _asMap(result);
  return matches(map) ? map : null;
}

List<T> _decodeList<T>(
  dynamic raw,
  T Function(Map<String, dynamic> json) fromJson,
) {
  final items = _rawList(raw);
  if (items.isEmpty) return <T>[];

  final decoded = <T>[];
  for (var i = 0; i < items.length; i++) {
    final map = _mapOrNull(items[i]);
    if (map != null) decoded.add(fromJson(map));
  }
  return decoded;
}

List<Map<String, dynamic>> _records(dynamic raw) {
  final items = _rawList(raw);
  if (items.isEmpty) return <Map<String, dynamic>>[];

  final records = <Map<String, dynamic>>[];
  for (var i = 0; i < items.length; i++) {
    final map = _mapOrNull(items[i]);
    if (map != null) records.add(map);
  }
  return records;
}

List<dynamic> _rawList(dynamic raw) {
  if (raw is List) return raw;
  if (raw is! Map) {
    throw const _HealthApiException('Unexpected server response');
  }

  final embedded = _embeddedMessage(raw);
  if (embedded != null) throw _HealthApiException(embedded);
  if (raw['errors'] != null || raw['success'] == false) {
    throw _HealthApiException(_readableMessage(raw));
  }

  final data = raw['data'];
  if (data is List) return data;
  if (data is Map && data['data'] is List) return data['data'] as List;
  if (data == null) return const [];

  throw _HealthApiException(_readableMessage(raw));
}

Map<String, dynamic> _asMap(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  throw const _HealthApiException('Unexpected server response');
}

Map<String, dynamic>? _mapOrNull(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return null;
}

String? _embeddedMessage(Map raw) {
  final original = raw['original'];
  if (original is! Map) return null;
  final message = original['message'];
  if (message == null) return null;
  final text = message.toString().trim();
  return text.isEmpty ? null : text;
}

String _readableMessage(Map raw) {
  final embedded = _embeddedMessage(raw);
  if (embedded != null) return embedded;

  final errors = raw['errors'];
  if (errors is Map) {
    for (final value in errors.values) {
      if (value is List && value.isNotEmpty) return value.first.toString();
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
  }

  final message = raw['message'];
  if (message != null && message.toString().trim().isNotEmpty) {
    return message.toString();
  }
  return 'Unexpected server response';
}

bool _isWeightBody(Map<String, dynamic> json) =>
    json.containsKey('bmi') ||
    json.containsKey('ideal_range') ||
    json['status'] is String;

bool _isPregnancyCalc(Map<String, dynamic> json) =>
    json.containsKey('last_period_date') &&
    (json.containsKey('result') || json.containsKey('user_id'));

bool _isPregnancyResult(Map<String, dynamic> json) =>
    json.containsKey('current_week');
