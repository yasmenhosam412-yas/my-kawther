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
    final today = json['is_today'];
    return DayInfo(
      date: json['date']?.toString() ?? '',
      month: json['month']?.toString() ?? '',
      phase: json['phase']?.toString() ?? '',
      pregnancyChance: json['pregnancy_chance']?.toString() ?? '',
      isToday: today == true || today == 1 || today == '1',
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
    final parsedMonths = <String, List<DayInfo>>{};
    final monthsJson = json['months'];
    if (monthsJson is Map) {
      for (final entry in monthsJson.entries) {
        final value = entry.value;
        if (value is! List) continue;
        final days = <DayInfo>[];
        for (final item in value) {
          if (item is! Map) continue;
          final day = DayInfo.fromJson(Map<String, dynamic>.from(item));
          if (day.date.isNotEmpty) days.add(day);
        }
        if (days.isNotEmpty) parsedMonths['${entry.key}'] = days;
      }
    }

    DayInfo? today;
    final todayJson = json['today'];
    if (todayJson is Map) {
      today = DayInfo.fromJson(Map<String, dynamic>.from(todayJson));
    }
    if (today == null || today.date.isEmpty) {
      DayInfo? fallback;
      for (final days in parsedMonths.values) {
        for (final day in days) {
          fallback ??= day;
          if (day.isToday) {
            today = day;
            break;
          }
        }
        if (today != null && today.date.isNotEmpty) break;
      }
      today ??= fallback;
    }
    if (today == null) {
      throw const FormatException('Missing fertility calendar days');
    }

    return MonthResponse(
      message: json['message']?.toString() ?? '',
      months: parsedMonths,
      today: today,
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
