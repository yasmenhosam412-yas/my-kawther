import 'package:dio/dio.dart';
import 'package:elkawther/features/health_services/models/pregnancy_calc_model.dart';
import 'package:elkawther/features/health_services/models/vaccines.dart';
import 'package:elkawther/features/health_services/models/weight_body.dart';
import 'package:elkawther/core/services/dio_service.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:elkawther/features/health_services/models/measures.dart';
import 'package:elkawther/features/health_services/models/month_response.dart';
import 'package:elkawther/features/health_services/models/monthly_period_calc_model.dart';

class HealthService {
  final Dio dio = DioService.dio;
  final SecureStorageHelper storageHelper = SecureStorageHelper();

  HealthService();

  Future<WeightBody> getBodyWeightData({
    required double weight,
    required double height,
    required String unit,
  }) async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.post(
      '/api/user/health/body-weight',
      data: {'weight': weight, 'height': height, 'unit': unit},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return WeightBody.fromJson(response.data['data']);
  }

  Future<MonthlyPeriodCalc> getPeriodData({
    required String startDayOfCycle,
    required int cycleLength,
    required int periodLength,
  }) async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.post(
      '/api/user/health/ovulation',
      data: {
        "start_day_of_cycle": startDayOfCycle,
        "cycle_length": cycleLength,
        "period_length": periodLength,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return MonthlyPeriodCalc.fromJson(response.data);
  }

  Future<MonthResponse> currentPeriodData() async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.get(
      '/api/user/health/ovulation/current',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return MonthResponse.fromJson(response.data);
  }

  Future<PregnancyCalcModel> getPreganacyCalcData({
    required String lastPeriodDate,
  }) async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.post(
      '/api/user/health/calculatePregnancy',
      data: {"last_period_date": lastPeriodDate},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final data = response.data;

    if (data is Map && data["original"]?["message"] != null) {
      throw data["original"]["message"];
    }

    return PregnancyCalcModel.fromJson(data);
  }

  Future<PregnancyResultModel> getPreganacyCalcCurrentData() async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.get(
      '/api/user/health/CurrentPregnancyStage',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return PregnancyResultModel.fromJson(response.data);
  }

  Future<BloodMeasureModel> getBloodMesureData({
    required int systolic,
    required int diastolic,
    required String conditionType,
    required String measuredAt,
  }) async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.post(
      '/api/user/health/blood-pressure',
      data: {
        "systolic": systolic,
        "diastolic": diastolic,
        "condition_type": conditionType,
        "measured_at": measuredAt,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return BloodMeasureModel.fromJson(response.data);
  }

  Future<List<BloodPressureDataFetched>> getBloodMesureDataFetched() async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.get(
      '/api/user/health/blood-pressure',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    final List<dynamic> rawData = response.data['data'];
    return rawData.map((e) => BloodPressureDataFetched.fromJson(e)).toList();
  }

  Future<BloodSugarModel> getBloodSugarMesureData({
    required int value,
    required String conditionType,
    required String measuredAt,
  }) async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.post(
      '/api/user/health/blood-sugar',
      data: {
        "value": value,
        "condition_type": conditionType,
        "measured_at": measuredAt,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return BloodSugarModel.fromJson(response.data);
  }

  Future<List<BloodSugarDataFetched>> fetchBloodSugarMeasureData() async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.get(
      '/api/user/health/blood-sugar',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    List<dynamic> rawData = response.data['data'];
    return rawData.map((data) => BloodSugarDataFetched.fromJson(data)).toList();
  }

  Future<VaccinesModel> getVaccinesData({
    required String babyName,
    required String babyGender,
    required String babyBirth,
  }) async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.post(
      '/api/user/health/child',
      data: {
        "child_name": babyName,
        "gender": babyGender,
        "birth_date": babyBirth,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return VaccinesModel.fromJson(response.data);
  }

  Future<ChildrenResponse> getVaccinesFullDataChildren() async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.get(
      '/api/user/health/child/vaccines',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return ChildrenResponse.fromJson(response.data);
  }

  Future<CompletedVaccines> updateVaccinesData({required int vacID}) async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.patch(
      '/api/user/health/vaccines/$vacID/complete',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return CompletedVaccines.fromJson(response.data);
  }

  Future<String> deleteChild(int childId) async {
    final token = await storageHelper.safeRead('token');
    final response = await dio.delete(
      '/api/user/health/child/$childId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    return response.data['message'];
  }
}
