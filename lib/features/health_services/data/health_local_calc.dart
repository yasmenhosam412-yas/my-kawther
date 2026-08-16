import 'package:elkawther/features/health_services/models/measures.dart';
import 'package:elkawther/features/health_services/models/month_response.dart'
    as calendar;
import 'package:elkawther/features/health_services/models/monthly_period_calc_model.dart';
import 'package:elkawther/features/health_services/models/pregnancy_calc_model.dart';
import 'package:elkawther/features/health_services/models/vaccines.dart';
import 'package:elkawther/features/health_services/models/weight_body.dart';
import 'package:intl/intl.dart';

class HealthLocalCalc {
  const HealthLocalCalc._();

  static final _date = DateFormat('yyyy-MM-dd', 'en');

  static WeightBody bodyWeight({
    required double weightKg,
    required double heightCm,
  }) {
    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);
    late final String status;
    late final String description;
    if (bmi < 18.5) {
      status = 'نقص الوزن';
      description = 'وزنك أقل من المعدل الطبيعي.';
    } else if (bmi < 25) {
      status = 'وزن طبيعي';
      description = 'وزنك ضمن المعدل الصحي.';
    } else if (bmi < 30) {
      status = 'زيادة وزن';
      description = 'وزنك أعلى من المعدل الطبيعي.';
    } else {
      status = 'سمنة';
      description = 'ينصح بمتابعة نمط الغذاء والنشاط.';
    }
    final min = 18.5 * heightM * heightM;
    final max = 24.9 * heightM * heightM;
    return WeightBody(
      bmi: bmi,
      status: status,
      description: description,
      idealRange: '${min.toStringAsFixed(0)} - ${max.toStringAsFixed(0)} كجم',
    );
  }

  static String bloodPressureEvaluation(int systolic, int diastolic) {
    if (systolic < 90 || diastolic < 60) return 'منخفض';
    if (systolic < 120 && diastolic < 80) return 'طبيعي';
    if (systolic < 130 && diastolic < 80) return 'مرتفع قليلاً';
    if (systolic < 140 || diastolic < 90) return 'مرتفع المرحلة 1';
    return 'مرتفع';
  }

  static String sugarEvaluation(int value, String conditionType) {
    final fasting = conditionType == 'fasting' || conditionType == 'صائم';
    if (fasting) {
      if (value < 70) return 'منخفض';
      if (value < 100) return 'طبيعي';
      if (value < 126) return 'مقدمات سكري';
      return 'مرتفع';
    }
    if (value < 70) return 'منخفض';
    if (value < 140) return 'طبيعي';
    if (value < 200) return 'مرتفع';
    return 'مرتفع جداً';
  }

  static MonthlyPeriodCalc period({
    required DateTime startDay,
    required int cycleLength,
    required int periodLength,
  }) {
    final ovulation = startDay.add(Duration(days: cycleLength - 14));
    final fertileStart = ovulation.subtract(const Duration(days: 5));
    final fertileEnd = ovulation.add(const Duration(days: 1));
    final days = <DayInfo>[];
    for (var i = 0; i < cycleLength; i++) {
      final date = startDay.add(Duration(days: i));
      late final String phase;
      late final String chance;
      if (i < periodLength) {
        phase = 'حيض';
        chance = '1%';
      } else if (!date.isBefore(fertileStart) && !date.isAfter(fertileEnd)) {
        phase = 'خصوبة';
        chance = date == ovulation ? '30%' : '25%';
      } else {
        phase = 'عادي';
        chance = '5%';
      }
      days.add(
        DayInfo(
          date: _date.format(date),
          phase: phase,
          pregnancyChance: chance,
        ),
      );
    }

    return MonthlyPeriodCalc(
      message: 'Success',
      data: PeriodData(
        period: PeriodInfo(
          userId: 0,
          startDayOfCycle: startDay,
          cycleLength: cycleLength,
          periodLength: periodLength,
        ),
        ovulationDate: _date.format(ovulation),
        fertileStart: _date.format(fertileStart),
        fertileEnd: _date.format(fertileEnd),
        days: days,
      ),
    );
  }

  static calendar.MonthResponse monthResponse(MonthlyPeriodCalc calc) {
    final months = <String, List<calendar.DayInfo>>{};
    final today = DateTime.now();
    calendar.DayInfo? todayInfo;
    for (final day in calc.data.days) {
      final parsed = DateTime.tryParse(day.date);
      if (parsed == null) continue;
      final key = DateFormat('MMMM yyyy', 'en').format(parsed);
      final info = calendar.DayInfo(
        date: day.date,
        month: key,
        phase: day.phase,
        pregnancyChance: day.pregnancyChance,
        isToday: _date.format(parsed) == _date.format(today),
      );
      months.putIfAbsent(key, () => []).add(info);
      if (info.isToday) todayInfo = info;
    }
    final fallback = months.values.first.first;
    return calendar.MonthResponse(
      message: 'Success',
      months: months,
      today: todayInfo ?? fallback,
    );
  }

  static PregnancyCalcModel pregnancy(DateTime lastPeriod) {
    final due = lastPeriod.add(const Duration(days: 280));
    final now = DateTime.now();
    final elapsed = now.difference(lastPeriod).inDays.clamp(0, 294);
    final week = (elapsed / 7).floor().clamp(1, 42);
    final day = elapsed % 7;
    final month = ((week - 1) / 4).floor() + 1;
    final result = PregnancyResultModel(
      lastPeriodDate: _date.format(lastPeriod),
      dueDate: _date.format(due),
      currentWeek: week,
      currentDay: day,
      monthInfo: 'الشهر $month',
      babySize: _babySize(week),
      babyWeight: _babyWeight(week),
      babyLength: _babyLength(week),
      imageStage: (week / 4).ceil().clamp(1, 10),
    );
    return PregnancyCalcModel(
      userId: 0,
      lastPeriodDate: lastPeriod,
      dueDate: due,
      result: result,
      updatedAt: now,
      createdAt: now,
      id: now.millisecondsSinceEpoch,
    );
  }

  static Child child({
    required String name,
    required String gender,
    required DateTime birthDate,
    int? id,
  }) {
    final now = DateTime.now();
    final childId = id ?? now.millisecondsSinceEpoch;
    const schedule = [
      (0, 'BCG', 'لقاح السل'),
      (42, 'Hep B', 'التهاب الكبد B'),
      (60, 'DTaP', 'الثلاثي البكتيري'),
      (120, 'Polio', 'شلل الأطفال'),
      (180, 'Hib', 'المستدمية النزلية'),
      (365, 'MMR', 'الحصبة والنكاف والحصبة الألمانية'),
    ];
    return Child(
      id: childId,
      userId: 0,
      childName: name,
      gender: gender,
      birthDate: _date.format(birthDate),
      createdAt: now.toIso8601String(),
      updatedAt: now.toIso8601String(),
      vaccines: [
        for (var i = 0; i < schedule.length; i++)
          Vaccine(
            id: childId + i + 1,
            childId: childId,
            vaccineName: schedule[i].$2,
            description: schedule[i].$3,
            scheduledDate: _date.format(
              birthDate.add(Duration(days: schedule[i].$1)),
            ),
            isCompleted: false,
            createdAt: now.toIso8601String(),
            updatedAt: now.toIso8601String(),
          ),
      ],
    );
  }

  static String _babySize(int week) {
    if (week < 8) return 'حبة سمسم';
    if (week < 12) return 'حبة ليمون';
    if (week < 20) return 'موزة';
    if (week < 28) return 'باذنجان';
    return 'حجم ثمرة شمام';
  }

  static String _babyWeight(int week) {
    if (week < 12) return '14 جم';
    if (week < 20) return '300 جم';
    if (week < 28) return '1 كجم';
    return '2.5 كجم';
  }

  static String _babyLength(int week) {
    if (week < 12) return '5 سم';
    if (week < 20) return '16 سم';
    if (week < 28) return '35 سم';
    return '45 سم';
  }
}

class HealthLocalStore {
  HealthLocalStore._() {
    children.addAll([
      HealthLocalCalc.child(
        id: 1001,
        name: 'يوسف أحمد',
        gender: 'ذكر',
        birthDate: DateTime.now().subtract(const Duration(days: 120)),
      ),
      HealthLocalCalc.child(
        id: 1002,
        name: 'ليان محمد',
        gender: 'أنثى',
        birthDate: DateTime.now().subtract(const Duration(days: 40)),
      ),
    ]);
  }
  static final HealthLocalStore instance = HealthLocalStore._();

  final List<Child> children = [];
  final List<BloodPressureDataFetched> bloodPressure = [];
  final List<BloodSugarDataFetched> bloodSugar = [];
  calendar.MonthResponse? monthResponse;

  void addChild(Child child) => children.insert(0, child);

  void removeChild(int id) => children.removeWhere((child) => child.id == id);

  Child? childById(int id) {
    for (final child in children) {
      if (child.id == id) return child;
    }
    return null;
  }

  Child completeVaccine({
    required int childId,
    required int vaccineId,
    Child? fallback,
  }) {
    var index = children.indexWhere((child) => child.id == childId);
    if (index < 0 && fallback != null) {
      children.add(fallback);
      index = children.length - 1;
    }
    if (index < 0) {
      throw StateError('Child not found');
    }
    final current = children[index];
    final updated = Child(
      id: current.id,
      userId: current.userId,
      childName: current.childName,
      gender: current.gender,
      birthDate: current.birthDate,
      createdAt: current.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
      vaccines: [
        for (final vaccine in current.vaccines)
          if (vaccine.id == vaccineId)
            Vaccine(
              id: vaccine.id,
              childId: vaccine.childId,
              vaccineName: vaccine.vaccineName,
              description: vaccine.description,
              scheduledDate: vaccine.scheduledDate,
              isCompleted: true,
              createdAt: vaccine.createdAt,
              updatedAt: DateTime.now().toIso8601String(),
            )
          else
            vaccine,
      ],
    );
    children[index] = updated;
    return updated;
  }
}
