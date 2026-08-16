class MonthlyPeriodCalc {
  final String message;
  final PeriodData data;

  MonthlyPeriodCalc({required this.message, required this.data});

  factory MonthlyPeriodCalc.fromJson(Map<String, dynamic> json) {
    return MonthlyPeriodCalc(
      message: json['message'] ?? 'Success',
      data: PeriodData.fromJson(json['data'] ?? {}),
    );
  }
}

class PeriodData {
  final PeriodInfo period;
  final String ovulationDate;
  final String fertileStart;
  final String fertileEnd;
  final List<DayInfo> days;

  PeriodData({
    required this.period,
    required this.ovulationDate,
    required this.fertileStart,
    required this.fertileEnd,
    required this.days,
  });

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    return PeriodData(
      period: PeriodInfo.fromJson(json['period'] ?? {}),
      ovulationDate: json['ovulation_date'] ?? '',
      fertileStart: json['fertile_start'] ?? '',
      fertileEnd: json['fertile_end'] ?? '',
      days:
          (json['days'] as List<dynamic>? ?? [])
              .map((x) => DayInfo.fromJson(x ?? {}))
              .toList(),
    );
  }
}

class PeriodInfo {
  final int userId;
  final DateTime startDayOfCycle;
  final int cycleLength;
  final int periodLength;

  PeriodInfo({
    required this.userId,
    required this.startDayOfCycle,
    required this.cycleLength,
    required this.periodLength,
  });

  factory PeriodInfo.fromJson(Map<String, dynamic> json) {
    return PeriodInfo(
      userId: json['user_id'] ?? 0,
      startDayOfCycle:
          DateTime.tryParse(json['start_day_of_cycle'] ?? '') ?? DateTime.now(),
      cycleLength: json['cycle_length'] ?? 28,
      periodLength: json['period_length'] ?? 5,
    );
  }
}

class DayInfo {
  final String date;
  final String phase;
  final String pregnancyChance;

  DayInfo({
    required this.date,
    required this.phase,
    required this.pregnancyChance,
  });

  factory DayInfo.fromJson(Map<String, dynamic> json) {
    return DayInfo(
      date: json['date'] ?? '',
      phase: json['phase'] ?? '',
      pregnancyChance: json['pregnancy_chance'] ?? '',
    );
  }
}
