import 'package:elkawther/features/my_dose/models/medication_model.dart';

class DailyMedicationModel {
  final String day;
  final List<MedicationModel> medications;

  DailyMedicationModel({required this.day, required this.medications});

  factory DailyMedicationModel.fromJson(Map<String, dynamic> json) {
    return DailyMedicationModel(
      day: json['day'],
      medications:
          (json['medications'] as List)
              .map((e) => MedicationModel.fromJson(e))
              .toList(),
    );
  }

  List<MedicationModel> getMedicationsForDay(String day) {
    return medications.where((med) => med.shouldDisplayForDay(day)).toList();
  }

  static List<MedicationModel> getAllMedicationsForDay(
    List<DailyMedicationModel> allDailyMeds,
    String targetDay,
  ) {
    List<MedicationModel> result = [];

    for (var dailyMed in allDailyMeds) {
      for (var medication in dailyMed.medications) {
        if (medication.shouldDisplayForDay(targetDay)) {
          result.add(medication);
        }
      }
    }

    return result;
  }
}
