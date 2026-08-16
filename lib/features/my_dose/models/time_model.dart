class TimeModel {
  final int id;
  final int medicationId;
  final String time;
  final String status;

  const TimeModel({
    required this.id,
    required this.medicationId,
    required this.time,
    required this.status,
  });

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    return TimeModel(
      id: json['id'],
      medicationId: json['medication_id'],
      time: json['time'],
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'medication_id': id,
    'time': time,
    'status': status,
  };

  TimeModel copyWith({
    int? id,
    int? medicationId,
    String? time,
    String? status,
  }) {
    return TimeModel(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      time: time ?? this.time,
      status: status ?? this.status,
    );
  }
}
