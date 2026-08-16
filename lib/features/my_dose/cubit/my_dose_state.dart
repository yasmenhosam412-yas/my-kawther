import 'package:elkawther/core/errors/errors.dart';

import 'package:elkawther/features/my_dose/models/daily_medication_model.dart';

abstract class MedicationState {}

class MedicationInitial extends MedicationState {}

class MedicationLoading extends MedicationState {}

class MedicationLoaded extends MedicationState {
  final List<DailyMedicationModel> data;
  MedicationLoaded(this.data);
}

class MedicationError extends MedicationState {
  final Errors msg;
  MedicationError(this.msg);
}

class AddMedicationLoading extends MedicationState {}

class AddMedicationSuccess extends MedicationState {}

class AddMedicationError extends MedicationState {
  final Errors message;
  AddMedicationError(this.message);
}

class DeleteMedicationSuccess extends MedicationState {}

class RemoveFromDaySuccess extends MedicationState {}

class UpdateMedicationLogSuccess extends MedicationState {}

class EditMedicationLoading extends MedicationState {}

class EditMedicationSuccess extends MedicationState {}

class EditMedicationError extends MedicationState {
  final Errors message;

  EditMedicationError(this.message);
}
