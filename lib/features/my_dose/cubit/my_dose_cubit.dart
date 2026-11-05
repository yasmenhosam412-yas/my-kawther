import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/features/my_dose/models/daily_medication_model.dart';
import 'package:elkawther/features/my_dose/models/medication_model.dart';
import 'package:elkawther/features/my_dose/services/my_dose_service.dart';
import 'package:elkawther/features/my_dose/cubit/my_dose_state.dart';

class MedicationCubit extends Cubit<MedicationState> {
  MedicationCubit(this.medicationService) : super(MedicationInitial());

  final MedicationService medicationService;
  List<DailyMedicationModel> dailyMeds = [];

  Future<void> fetchAllMedications() async {
    if (isClosed) return;
    emit(MedicationLoading());
    try {
      dailyMeds = await medicationService.getAllMedications();
      if (!isClosed) emit(MedicationLoaded(List.unmodifiable(dailyMeds)));
    } on DioException catch (error) {
      if (!isClosed) emit(MedicationError(Errors.fromDioError(error)));
    } catch (error) {
      if (!isClosed) emit(MedicationError(Errors(message: error.toString())));
    }
  }

  Future<MedicationModel?> addMedication(FormData data) async {
    emit(AddMedicationLoading());
    try {
      final medication = await medicationService.addMedication(data);
      emit(AddMedicationSuccess());
      await fetchAllMedications();
      return medication;
    } on DioException catch (error) {
      if (!isClosed) emit(AddMedicationError(Errors.fromDioError(error)));
    } catch (error) {
      if (!isClosed) {
        emit(AddMedicationError(Errors(message: error.toString())));
      }
    }
    return null;
  }

  Future<MedicationModel?> editMedication(int id, FormData data) async {
    emit(EditMedicationLoading());
    try {
      final medication = await medicationService.editMedication(data, id);
      emit(EditMedicationSuccess());
      await fetchAllMedications();
      return medication;
    } on DioException catch (error) {
      if (!isClosed) emit(EditMedicationError(Errors.fromDioError(error)));
    } catch (error) {
      if (!isClosed) {
        emit(EditMedicationError(Errors(message: error.toString())));
      }
    }
    return null;
  }

  Future<bool> deleteMedication(int id) async {
    emit(MedicationLoading());
    try {
      await medicationService.deleteMedication(id);
      emit(DeleteMedicationSuccess());
      await fetchAllMedications();
      return true;
    } on DioException catch (error) {
      if (!isClosed) emit(MedicationError(Errors.fromDioError(error)));
    } catch (error) {
      if (!isClosed) emit(MedicationError(Errors(message: error.toString())));
    }
    return false;
  }

  Future<bool> removeMedicationFromDay(int medicationId, String day) async {
    emit(MedicationLoading());
    try {
      await medicationService.removeMedicationFromDay(
        medicationId: medicationId,
        day: day,
      );
      emit(RemoveFromDaySuccess());
      await fetchAllMedications();
      return true;
    } on DioException catch (error) {
      if (!isClosed) emit(MedicationError(Errors.fromDioError(error)));
    } catch (error) {
      if (!isClosed) emit(MedicationError(Errors(message: error.toString())));
    }
    return false;
  }

  Future<bool> updateMedicationLog({
    required int medicationId,
    required String time,
    required String status,
    required String shownDate,
  }) async {
    try {
      await medicationService.updateMedicationLog(
        medicationId: medicationId,
        time: time,
        status: status,
        shownDate: shownDate,
      );
      emit(UpdateMedicationLogSuccess());
      await fetchAllMedications();
      return true;
    } on DioException catch (error) {
      if (!isClosed) emit(MedicationError(Errors.fromDioError(error)));
    } catch (error) {
      if (!isClosed) emit(MedicationError(Errors(message: error.toString())));
    }
    return false;
  }
}
