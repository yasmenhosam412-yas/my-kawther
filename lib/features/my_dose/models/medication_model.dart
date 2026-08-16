import 'package:elkawther/features/my_dose/models/time_model.dart';

class DayMedication {
  final String day;
  final List<MedicationModel> medications;

  DayMedication({required this.day, required this.medications});

  factory DayMedication.fromJson(Map<String, dynamic> json) {
    return DayMedication(
      day: json['day'],
      medications:
          (json['medications'] as List)
              .map((e) => MedicationModel.fromJson(e))
              .toList(),
    );
  }
}

class MedicationModel {
  final int id;
  final String name;
  final String? notes;
  final String? imagePath;
  final int quantityPerTime;
  final String repeatType;
  final List<String> days;
  final List<TimeModel> times;

  MedicationModel({
    required this.id,
    required this.name,
    this.notes,
    this.imagePath,
    required this.quantityPerTime,
    required this.repeatType,
    required this.days,
    required this.times,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      notes: json['notes'],
      imagePath: json['image_url'] ?? "",
      quantityPerTime:
          (json['quantity_per_time'] == null)
              ? 0
              : (json['quantity_per_time'] is int
                  ? json['quantity_per_time']
                  : int.tryParse(json['quantity_per_time'].toString()) ?? 0),
      repeatType: json['repeat_type'] ?? '',
      days: (json['days'] as List? ?? []).map((e) => e.toString()).toList(),
      times:
          (json['times'] as List? ?? [])
              .map((e) => TimeModel.fromJson(e))
              .toList(),
    );
  }

  bool shouldDisplayForDay(String day) {
    final key = day.toLowerCase();
    if (days.any((item) => item.toLowerCase() == 'everyday')) return true;
    if (repeatType == 'every_day') return true;
    return days.any((item) => item.toLowerCase() == key);
  }

  MedicationModel copyWith({
    int? id,
    String? name,
    String? notes,
    String? imagePath,
    int? quantityPerTime,
    String? repeatType,
    List<String>? days,
    List<TimeModel>? times,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      quantityPerTime: quantityPerTime ?? this.quantityPerTime,
      repeatType: repeatType ?? this.repeatType,
      days: days ?? this.days,
      times: times ?? this.times,
    );
  }
}
