class MonthlyPeriodCalc {
  final String message;
  final PeriodData data;

  MonthlyPeriodCalc({required this.message, required this.data});

  factory MonthlyPeriodCalc.fromJson(Map<String, dynamic> json) {
    final payload = _periodPayload(json);
    return MonthlyPeriodCalc(
      message: json['message']?.toString() ?? 'Success',
      data: PeriodData.fromJson(payload),
    );
  }

  bool get hasCycleDays => data.days.any((day) => day.date.isNotEmpty);
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
    final periodJson =
        json['period'] is Map
            ? Map<String, dynamic>.from(json['period'] as Map)
            : json;
    final fertile = json['fertile_window'] ?? json['fertile'];
    final fertileMap =
        fertile is Map
            ? Map<String, dynamic>.from(fertile)
            : const <String, dynamic>{};

    return PeriodData(
      period: PeriodInfo.fromJson(periodJson),
      ovulationDate: _dateText(
        json['ovulation_date'] ?? json['ovulation'] ?? json['ovulation_day'],
      ),
      fertileStart: _dateText(
        json['fertile_start'] ??
            json['fertile_window_start'] ??
            fertileMap['start'] ??
            fertileMap['from'],
      ),
      fertileEnd: _dateText(
        json['fertile_end'] ??
            json['fertile_window_end'] ??
            fertileMap['end'] ??
            fertileMap['to'],
      ),
      days: _dayList(
        json['days'] ?? json['calendar'] ?? json['cycle_days'] ?? json['dates'],
      ),
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
    final start = _parseDate(
      json['start_day_of_cycle'] ??
          json['start_date'] ??
          json['last_period_date'] ??
          json['date'],
    );
    return PeriodInfo(
      userId: _asInt(json['user_id']) ?? 0,
      startDayOfCycle: start ?? DateTime.now(),
      cycleLength: _asInt(json['cycle_length'] ?? json['cycle']) ?? 28,
      periodLength: _asInt(json['period_length'] ?? json['duration']) ?? 5,
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
      date: _dateText(json['date'] ?? json['day']),
      phase: _phaseText(json['phase'] ?? json['status'] ?? json['type']),
      pregnancyChance: _chanceText(
        json['pregnancy_chance'] ?? json['chance'] ?? json['probability'],
      ),
    );
  }
}

Map<String, dynamic> _periodPayload(Map<String, dynamic> json) {
  final data = json['data'];
  if (data is Map) {
    final map = Map<String, dynamic>.from(data);
    final nested = map['data'];
    final hasCycle =
        map['period'] != null ||
        map['days'] != null ||
        map['ovulation_date'] != null ||
        map['ovulation'] != null;
    if (!hasCycle && nested is Map) return Map<String, dynamic>.from(nested);
    if (hasCycle || map.isNotEmpty) return map;
  }
  return json;
}

List<DayInfo> _dayList(dynamic raw) {
  if (raw is! List) return const [];
  final days = <DayInfo>[];
  for (final item in raw) {
    if (item is! Map) continue;
    final day = DayInfo.fromJson(Map<String, dynamic>.from(item));
    if (day.date.isNotEmpty) days.add(day);
  }
  return days;
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.round();
  return int.tryParse(value?.toString() ?? '');
}

String _dateText(dynamic value) {
  final parsed = _parseDate(value);
  if (parsed == null) return '';
  final month = parsed.month.toString().padLeft(2, '0');
  final day = parsed.day.toString().padLeft(2, '0');
  return '${parsed.year}-$month-$day';
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty) return null;

  final iso = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(text);
  if (iso != null) {
    return DateTime(
      int.parse(iso.group(1)!),
      int.parse(iso.group(2)!),
      int.parse(iso.group(3)!),
    );
  }

  final parts = text.split(RegExp(r'[\/\-.]'));
  if (parts.length >= 3 && parts[0].length <= 2 && parts[2].length == 4) {
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day != null && month != null && year != null) {
      return DateTime(year, month, day);
    }
  }
  return null;
}

String _chanceText(dynamic value) {
  if (value == null) return '';
  if (value is num) return _percent(value);
  final text = value.toString().trim();
  if (text.isEmpty) return '';
  if (text.contains('%')) return text;
  final number = num.tryParse(text);
  return number == null ? text : _percent(number);
}

String _percent(num value) {
  final shown = value <= 1 ? (value * 100).round() : value.round();
  return '$shown%';
}

String _phaseText(dynamic value) {
  final text = value?.toString().trim() ?? '';
  switch (text.toLowerCase()) {
    case 'period':
    case 'menstruation':
    case 'menses':
      return 'حيض';
    case 'ovulation':
      return 'تبويض';
    case 'fertile':
    case 'high fertility':
    case 'peak':
      return 'خصوبة عالية';
    case 'medium fertility':
      return 'خصوبة متوسطة';
    case 'low fertility':
      return 'خصوبة منخفضة';
    case 'infertile':
    case 'safe':
    case 'normal':
      return 'غير خصبة';
    case 'post ovulation':
    case 'luteal':
      return 'ما بعد التبويض';
    default:
      return text;
  }
}
