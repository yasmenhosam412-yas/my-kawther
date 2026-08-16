class PregnancyCalcModel {
  final int userId;
  final DateTime lastPeriodDate;
  final DateTime dueDate;
  final PregnancyResultModel result;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  PregnancyCalcModel({
    required this.userId,
    required this.lastPeriodDate,
    required this.dueDate,
    required this.result,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory PregnancyCalcModel.fromJson(Map<String, dynamic> json) {
    return PregnancyCalcModel(
      userId: json['user_id'],
      lastPeriodDate: DateTime.parse(json['last_period_date']),
      dueDate: DateTime.parse(json['due_date']),
      result: PregnancyResultModel.fromJson(json['result']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'last_period_date': lastPeriodDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'result': result.toJson(),
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'id': id,
    };
  }
}

class PregnancyResultModel {
  final String lastPeriodDate;
  final String dueDate;
  final int currentWeek;
  final int currentDay;
  final String monthInfo;
  final String babySize;
  final String babyWeight;
  final String babyLength;
  final int imageStage;

  PregnancyResultModel({
    required this.lastPeriodDate,
    required this.dueDate,
    required this.currentWeek,
    required this.currentDay,
    required this.monthInfo,
    required this.babySize,
    required this.babyWeight,
    required this.babyLength,
    required this.imageStage,
  });

  factory PregnancyResultModel.fromJson(Map<String, dynamic> json) {
    return PregnancyResultModel(
      lastPeriodDate: json['last_period_date'],
      dueDate: json['due_date'],
      currentWeek: json['current_week'],
      currentDay: json['current_day'],
      monthInfo: json['month_info'],
      babySize: json['baby_size'],
      babyWeight: json['baby_weight'],
      babyLength: json['baby_length'],
      imageStage: json['image_stage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'last_period_date': lastPeriodDate,
      'due_date': dueDate,
      'current_week': currentWeek,
      'current_day': currentDay,
      'month_info': monthInfo,
      'baby_size': babySize,
      'baby_weight': babyWeight,
      'baby_length': babyLength,
      'image_stage': imageStage,
    };
  }
}
