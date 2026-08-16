class BloodSugarModel {
  final String message;
  final BloodSugarData data;

  BloodSugarModel({required this.message, required this.data});

  factory BloodSugarModel.fromJson(Map<String, dynamic> json) {
    return BloodSugarModel(
      message: json['message'],
      data: BloodSugarData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data.toJson()};
  }
}

class BloodSugarData {
  final int value;
  final String conditionType;
  final DateTime measuredAt;
  final String evaluation;

  BloodSugarData({
    required this.value,
    required this.conditionType,
    required this.measuredAt,
    required this.evaluation,
  });

  factory BloodSugarData.fromJson(Map<String, dynamic> json) {
    return BloodSugarData(
      value: json['value'],
      conditionType: json['condition_type'],
      measuredAt: DateTime.parse(json['measured_at']),
      evaluation: json['evaluation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'condition_type': conditionType,
      'measured_at': measuredAt.toIso8601String(),
      'evaluation': evaluation,
    };
  }
}

class BloodSugarDataFetched {
  final int value;
  final String conditionType;
  final String measuredAt;

  BloodSugarDataFetched({
    required this.value,
    required this.conditionType,
    required this.measuredAt,
  });

  factory BloodSugarDataFetched.fromJson(Map<String, dynamic> json) {
    return BloodSugarDataFetched(
      value: json['value'],
      conditionType: json['condition_type'],
      measuredAt: json['measured_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'condition_type': conditionType,
      'measured_at': measuredAt,
    };
  }
}

//------------------------------------------------
class BloodMeasureModel {
  final String message;
  final BloodPressureData data;

  BloodMeasureModel({required this.message, required this.data});

  factory BloodMeasureModel.fromJson(Map<String, dynamic> json) {
    return BloodMeasureModel(
      message: json['message'],
      data: BloodPressureData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data.toJson()};
  }
}

class BloodPressureData {
  final int systolic;
  final int diastolic;
  final String conditionType;
  final DateTime measuredAt;
  final String evaluation;

  BloodPressureData({
    required this.systolic,
    required this.diastolic,
    required this.conditionType,
    required this.measuredAt,
    required this.evaluation,
  });

  factory BloodPressureData.fromJson(Map<String, dynamic> json) {
    return BloodPressureData(
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      conditionType: json['condition_type'],
      measuredAt: DateTime.parse(json['measured_at']),
      evaluation: json['evaluation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'systolic': systolic,
      'diastolic': diastolic,
      'condition_type': conditionType,
      'measured_at': measuredAt.toIso8601String(),
      'evaluation': evaluation,
    };
  }
}

class BloodPressureDataFetched {
  final int systolic;
  final int diastolic;
  final String conditionType;
  final String measuredAt;

  BloodPressureDataFetched({
    required this.systolic,
    required this.diastolic,
    required this.conditionType,
    required this.measuredAt,
  });

  factory BloodPressureDataFetched.fromJson(Map<String, dynamic> json) {
    return BloodPressureDataFetched(
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      conditionType: json['condition_type'],
      measuredAt: json['measured_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'systolic': systolic,
      'diastolic': diastolic,
      'condition_type': conditionType,
      'measured_at': measuredAt,
    };
  }
}
