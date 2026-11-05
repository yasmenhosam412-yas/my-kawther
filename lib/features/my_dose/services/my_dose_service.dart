import 'package:dio/dio.dart';

import 'package:elkawther/features/my_dose/models/daily_medication_model.dart';
import 'package:elkawther/features/my_dose/models/medication_model.dart';
import 'package:elkawther/core/services/dio_service.dart';

class MedicationService {
  final Dio _dio = DioService.dio;

  Future<List<DailyMedicationModel>> getAllMedications() async {
    final res = await _dio.get('/api/user/medication');
    final responseData = res.data;
    final data =
        responseData is Map<String, dynamic>
            ? responseData['data'] as List? ?? const []
            : responseData as List;
    return data.map((e) => DailyMedicationModel.fromJson(e)).toList();
  }

  Future<MedicationModel> addMedication(FormData data) async {
    final res = await _dio.post('/api/user/medication', data: data);
    return MedicationModel.fromJson(_resourceData(res.data));
  }

  Future<MedicationModel> editMedication(FormData data, int id) async {
    final res = await _dio.post('/api/user/medications/$id/update', data: data);
    return MedicationModel.fromJson(_resourceData(res.data));
  }

  Future<void> deleteMedication(int id) async {
    await _dio.delete('/api/user/medication/$id');
  }

  Future<void> removeMedicationFromDay({
    required int medicationId,
    required String day,
  }) async {
    await _dio.delete(
      '/api/user/medications/remove-day',
      data: {'medication_id': medicationId, 'day': day},
    );
  }

  Future<void> updateMedicationLog({
    required int medicationId,
    required String time,
    required String status,
    required String shownDate,
  }) async {
    await _dio.post(
      '/api/user/medications/$medicationId/log',
      data: {'status': status, 'time': time, 'shown_date': shownDate},
    );
  }

  dynamic _resourceData(dynamic response) {
    if (response is Map<String, dynamic> && response['data'] is Map) {
      return response['data'];
    }
    return response;
  }
}
