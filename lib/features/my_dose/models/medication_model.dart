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
    final times = json['times'] as List? ?? const [];
    final days = json['days'] as List? ?? const [];
    return MedicationModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      notes: json['notes']?.toString(),
      imagePath: json['image_url']?.toString(),
      quantityPerTime:
          (json['quantity_per_time'] == null)
              ? 0
              : (json['quantity_per_time'] is int
                  ? json['quantity_per_time']
                  : int.tryParse(json['quantity_per_time'].toString()) ?? 0),
      repeatType: json['repeat_type']?.toString() ?? '',
      days:
          days
              .map((day) => day is Map ? day['day'].toString() : day.toString())
              .toList(),
      times:
          times
              .map(
                (time) => TimeModel.fromJson(Map<String, dynamic>.from(time)),
              )
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
