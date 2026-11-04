import 'package:elkawther/features/my_dose/models/medication_model.dart';
import 'package:elkawther/features/my_dose/models/time_model.dart';
import 'package:flutter/foundation.dart';

class DoseLocalStore extends ChangeNotifier {
  DoseLocalStore._() {
    _medications.addAll(_seed);
  }

  static final DoseLocalStore instance = DoseLocalStore._();

  static const _allDays = [
    'saturday',
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  ];

  final List<MedicationModel> _medications = [];
  int _nextId = 100;

  List<MedicationModel> get medications => List.unmodifiable(_medications);

  List<MedicationModel> forDay(String day) {
    final key = day.toLowerCase();
    return _medications
        .where((med) => med.shouldDisplayForDay(key) && med.times.isNotEmpty)
        .toList();
  }

  void markTaken({required int medicationId, required int timeId}) {
    final medIndex = _medications.indexWhere((med) => med.id == medicationId);
    if (medIndex == -1) return;
    final medication = _medications[medIndex];
    final times = [
      for (final time in medication.times)
        time.id == timeId ? time.copyWith(status: 'taken') : time,
    ];
    _medications[medIndex] = medication.copyWith(times: times);
    notifyListeners();
  }

  void removeFromDay(int medicationId, String day) {
    final medIndex = _medications.indexWhere((med) => med.id == medicationId);
    if (medIndex == -1) return;
    final medication = _medications[medIndex];
    final days =
        medication.days
            .where((item) => item.toLowerCase() != day.toLowerCase())
            .toList();
    if (days.isEmpty || days.contains('everyday')) {
      _medications.removeAt(medIndex);
    } else {
      _medications[medIndex] = medication.copyWith(days: days);
    }
    notifyListeners();
  }

  void deleteAll(int medicationId) {
    _medications.removeWhere((med) => med.id == medicationId);
    notifyListeners();
  }

  MedicationModel add({
    required String name,
    String? notes,
    String? imagePath,
    required int quantityPerTime,
    required String repeatType,
    required List<String> days,
    required List<String> times,
  }) {
    final id = _nextId++;
    final medication = MedicationModel(
      id: id,
      name: name,
      notes: notes,
      imagePath: imagePath,
      quantityPerTime: quantityPerTime,
      repeatType: repeatType,
      days: days,
      times: [
        for (var i = 0; i < times.length; i++)
          TimeModel(
            id: id * 10 + i,
            medicationId: id,
            time: times[i],
            status: 'pending',
          ),
      ],
    );
    _medications.add(medication);
    notifyListeners();
    return medication;
  }

  MedicationModel? update({
    required int id,
    required String name,
    String? notes,
    String? imagePath,
    required int quantityPerTime,
    required String repeatType,
    required List<String> days,
    required List<String> times,
  }) {
    final medIndex = _medications.indexWhere((med) => med.id == id);
    if (medIndex == -1) return null;
    final existing = _medications[medIndex];
    final updated = existing.copyWith(
      name: name,
      notes: notes,
      imagePath: imagePath,
      quantityPerTime: quantityPerTime,
      repeatType: repeatType,
      days: days,
      times: [
        for (var i = 0; i < times.length; i++)
          TimeModel(
            id: existing.times.length > i ? existing.times[i].id : id * 10 + i,
            medicationId: id,
            time: times[i],
            status:
                existing.times.length > i
                    ? existing.times[i].status
                    : 'pending',
          ),
      ],
    );
    _medications[medIndex] = updated;
    notifyListeners();
    return updated;
  }

  static final _seed = [
    MedicationModel(
      id: 1,
      name: 'بانادول 500 مجم',
      notes: 'قرص بعد الأكل للصداع والحرارة',
      quantityPerTime: 1,
      repeatType: 'every_day',
      days: _allDays,
      times: const [
        TimeModel(id: 11, medicationId: 1, time: '08:00:00', status: 'pending'),
        TimeModel(id: 12, medicationId: 1, time: '20:00:00', status: 'pending'),
      ],
    ),
    MedicationModel(
      id: 2,
      name: 'فيتامين د3 5000',
      notes: 'كبسولة يومياً بعد الإفطار',
      quantityPerTime: 1,
      repeatType: 'every_day',
      days: _allDays,
      times: const [
        TimeModel(id: 21, medicationId: 2, time: '09:00:00', status: 'pending'),
      ],
    ),
    MedicationModel(
      id: 3,
      name: 'ريدوكسون فيتامين سي 1000',
      notes: 'قرص فوار في كوب ماء صباحاً',
      quantityPerTime: 1,
      repeatType: 'every_day',
      days: _allDays,
      times: const [
        TimeModel(id: 31, medicationId: 3, time: '08:30:00', status: 'pending'),
      ],
    ),
    MedicationModel(
      id: 4,
      name: 'أوميغا 3',
      notes: 'كبسولة بعد العشاء',
      quantityPerTime: 1,
      repeatType: 'every_day',
      days: _allDays,
      times: const [
        TimeModel(id: 41, medicationId: 4, time: '21:00:00', status: 'pending'),
      ],
    ),
    MedicationModel(
      id: 5,
      name: 'مغنيسيوم B6',
      notes: 'قرص قبل النوم',
      quantityPerTime: 1,
      repeatType: 'specific_days',
      days: const ['sunday', 'tuesday', 'thursday'],
      times: const [
        TimeModel(id: 51, medicationId: 5, time: '22:00:00', status: 'pending'),
      ],
    ),
    MedicationModel(
      id: 6,
      name: 'ستربسلز عسل وليمون',
      notes: 'قرص استحلاب عند التهاب الحلق',
      quantityPerTime: 1,
      repeatType: 'specific_days',
      days: const ['saturday', 'sunday', 'monday'],
      times: const [
        TimeModel(id: 61, medicationId: 6, time: '12:00:00', status: 'pending'),
        TimeModel(id: 62, medicationId: 6, time: '18:00:00', status: 'pending'),
      ],
    ),
  ];
}
