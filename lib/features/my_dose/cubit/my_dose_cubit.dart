import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/features/my_dose/models/daily_medication_model.dart';
import 'package:elkawther/features/my_dose/models/medication_model.dart';
import 'package:elkawther/features/my_dose/models/time_model.dart';
import 'package:elkawther/features/my_dose/services/my_dose_service.dart';
import 'package:elkawther/features/my_dose/cubit/my_dose_state.dart';

class MedicationCubit extends Cubit<MedicationState> {
  final MedicationService medicationService;

  MedicationCubit(this.medicationService) : super(MedicationInitial());

  List<DailyMedicationModel> dailyMeds = [];

  Future<void> fetchAllMedications() async {
    if (isClosed) return;
    emit(MedicationLoading());
    try {
      dailyMeds = await medicationService.getAllMedications();
      if (isClosed) return;
      emit(MedicationLoaded(List.from(dailyMeds)));
    } on DioException catch (e) {
      if (isClosed) return;
      emit(MedicationError(Errors.fromDioError(e)));
    } catch (e) {
      if (isClosed) return;
      emit(MedicationError(Errors(message: e.toString())));
    }
  }

  Future<MedicationModel?> addMedication(
    FormData data,
    BuildContext context,
  ) async {
    emit(AddMedicationLoading());
    try {
      final newMed = await medicationService.addMedication(data);

      _addMedicationToLocal(newMed);

      emit(AddMedicationSuccess());
      emit(MedicationLoaded(List.from(dailyMeds)));

      return newMed;
    } on DioException catch (e) {
      if (!context.mounted) return null;
      emit(AddMedicationError(Errors.fromDioError(e)));
      return null;
    } catch (e) {
      if (!context.mounted) return null;
      emit(AddMedicationError(e is Errors ? e : Errors(message: e.toString())));
      return null;
    }
  }

  Future<MedicationModel?> editMedication(
    int id,
    FormData data,
    BuildContext context,
  ) async {
    emit(EditMedicationLoading());
    try {
      final updated = await medicationService.editMedication(data, id);
      await fetchAllMedications();

      emit(EditMedicationSuccess());
      return updated;
    } on DioException catch (e) {
      if (!context.mounted) return null;
      emit(AddMedicationError(Errors.fromDioError(e)));
    } catch (e) {
      if (!context.mounted) return null;
      emit(AddMedicationError(e is Errors ? e : Errors(message: e.toString())));
    }
    return null;
  }

  Future<void> deleteMedication(int id) async {
    emit(MedicationLoading());

    try {
      await medicationService.deleteMedication(id);

      for (final day in dailyMeds) {
        day.medications.removeWhere((med) => med.id == id);
      }

      dailyMeds.removeWhere((day) => day.medications.isEmpty);

      emit(DeleteMedicationSuccess());
      emit(MedicationLoaded(List.from(dailyMeds)));
    } on DioError catch (e) {
      emit(MedicationError(Errors.fromDioError(e)));
    } catch (e) {
      emit(MedicationError(Errors(message: e.toString())));
    }
  }

  Future<void> removeMedicationFromDay(int medicationId, String day) async {
    emit(MedicationLoading());

    try {
      await medicationService.removeMedicationFromDay(
        medicationId: medicationId,
        day: day,
      );

      final targetDay = dailyMeds.firstWhere(
        (d) => d.day.toLowerCase() == day.toLowerCase(),
        orElse: () => DailyMedicationModel(day: day, medications: []),
      );
      targetDay.medications.removeWhere((med) => med.id == medicationId);

      dailyMeds.removeWhere((d) => d.medications.isEmpty);

      emit(RemoveFromDaySuccess());
      emit(MedicationLoaded(List.from(dailyMeds)));
    } on DioError catch (e) {
      emit(MedicationError(Errors.fromDioError(e)));
    } catch (e) {
      emit(MedicationError(Errors(message: e.toString())));
    }
  }

  Future<void> updateMedicationLog({
    required int medicationId,
    required String time,
    required String status,
  }) async {
    try {
      await medicationService.updateMedicationLog(
        medicationId: medicationId,
        time: time,
        status: status,
      );

      bool updated = false;

      for (final day in dailyMeds) {
        for (final med in day.medications) {
          if (med.id == medicationId) {
            final index = med.times.indexWhere((t) => t.time == time);

            if (index != -1) {
              med.times[index] = TimeModel(
                id: med.times[index].id,
                time: med.times[index].time,
                status: status,
                medicationId: medicationId,
              );
            } else {
              med.times.add(
                TimeModel(
                  id: DateTime.now().millisecondsSinceEpoch,
                  time: time,
                  status: status,
                  medicationId: medicationId,
                ),
              );
            }

            updated = true;
            break;
          }
        }
        if (updated) break;
      }

      emit(MedicationLoaded(List.from(dailyMeds)));
    } on DioError catch (e) {
      emit(MedicationError(Errors.fromDioError(e)));
    } catch (e) {
      emit(MedicationError(Errors(message: e.toString())));
    }
  }

  void _addMedicationToLocal(MedicationModel newMed) {
    for (final day in newMed.days) {
      var targetDay = dailyMeds.firstWhere(
        (d) => d.day.toLowerCase() == day.toLowerCase(),
        orElse: () => DailyMedicationModel(day: day, medications: []),
      );

      if (!dailyMeds.contains(targetDay)) {
        dailyMeds.add(targetDay);
      }

      if (!targetDay.medications.any((med) => med.id == newMed.id)) {
        targetDay.medications.add(newMed);
      }
    }
  }
}
