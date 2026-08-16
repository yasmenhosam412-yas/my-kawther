import 'package:dio/dio.dart';

import 'package:elkawther/features/my_dose/models/daily_medication_model.dart';
import 'package:elkawther/features/my_dose/models/medication_model.dart';
import 'package:elkawther/core/services/dio_service.dart';

class MedicationService {
  final Dio _dio = DioService.dio;

  Future<List<DailyMedicationModel>> getAllMedications() async {
    final res = await _dio.get('/api/v1/user/medication');
    return (res.data as List)
        .map((e) => DailyMedicationModel.fromJson(e))
        .toList();
  }

  Future<MedicationModel> addMedication(FormData data) async {
    final res = await _dio.post('/api/v1/user/medication', data: data);
    return MedicationModel.fromJson(res.data['data']);
  }

  Future<MedicationModel> editMedication(FormData data, int id) async {
    final res = await _dio.post(
      '/api/v1/user/medications/$id/update',
      data: data,
    );
    return MedicationModel.fromJson(res.data);
  }

  Future<void> deleteMedication(int id) async {
    await _dio.delete('/api/v1/user/medication/$id');
  }

  Future<void> removeMedicationFromDay({
    required int medicationId,
    required String day,
  }) async {
    await _dio.request(
      '/api/v1/user/medications/remove-day',
      data: {'_method': 'delete', 'medication_id': medicationId, 'day': day},
      options: Options(method: 'POST'),
    );
  }

  Future<void> updateMedicationLog({
    required int medicationId,
    required String time,
    required String status,
  }) async {
    await _dio.post(
      '/api/v1/user/medications/$medicationId/log',
      data: {'status': status, 'time': time},
    );
  }
}
