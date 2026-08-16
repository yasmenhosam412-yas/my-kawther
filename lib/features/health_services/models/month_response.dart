// موديل DayInfo
class DayInfo {
  final String date;
  final String month;
  final String phase;
  final String pregnancyChance;
  final bool isToday;

  DayInfo({
    required this.date,
    required this.month,
    required this.phase,
    required this.pregnancyChance,
    required this.isToday,
  });

  factory DayInfo.fromJson(Map<String, dynamic> json) {
    return DayInfo(
      date: json['date'],
      month: json['month'] ?? '',
      phase: json['phase'],
      pregnancyChance: json['pregnancy_chance'],
      isToday: json['is_today'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "month": month,
      "phase": phase,
      "pregnancy_chance": pregnancyChance,
      "is_today": isToday,
    };
  }
}

// موديل MonthResponse
class MonthResponse {
  final String message;
  final Map<String, List<DayInfo>> months;
  final DayInfo today;

  MonthResponse({
    required this.message,
    required this.months,
    required this.today,
  });

  factory MonthResponse.fromJson(Map<String, dynamic> json) {
    final monthsJson = json['months'] as Map<String, dynamic>;
    final parsedMonths = monthsJson.map((key, value) {
      final days =
          (value as List).map((dayJson) => DayInfo.fromJson(dayJson)).toList();
      return MapEntry(key, days);
    });

    return MonthResponse(
      message: json['message'] ?? '',
      months: parsedMonths,
      today: DayInfo.fromJson(json['today']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "months": months.map(
        (key, value) =>
            MapEntry(key, value.map((day) => day.toJson()).toList()),
      ),
      "today": today.toJson(),
    };
  }
}
