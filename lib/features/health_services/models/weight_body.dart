class WeightBody {
  final double? bmi;
  final String? status;
  final String? description;
  final String? idealRange;

  WeightBody({
    required this.bmi,
    required this.status,
    required this.description,
    required this.idealRange,
  });

  factory WeightBody.fromJson(Map<String, dynamic> json) {
    return WeightBody(
      bmi: (json['bmi'] as num?)?.toDouble(),
      status: json['status'] as String?,
      description: json['description'] as String?,
      idealRange: json['ideal_range'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bmi': bmi,
      'status': status,
      'description': description,
      'ideal_range': idealRange,
    };
  }
}
