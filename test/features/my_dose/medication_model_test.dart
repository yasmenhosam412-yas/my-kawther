import 'package:elkawther/features/my_dose/models/daily_medication_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses the week-grouped medication response', () {
    final day = DailyMedicationModel.fromJson({
      'day': 'monday',
      'medications': [
        {
          'id': 42,
          'name': 'Panadol',
          'notes': 'After food',
          'image_url': 'https://example.test/medication/42',
          'quantity_per_time': '2',
          'repeat_type': 'specific_days',
          'days': ['monday', 'wednesday'],
          'times': [
            {
              'id': 100,
              'medication_id': 42,
              'time': '08:00:00',
              'status': 'taken',
            },
          ],
        },
      ],
    });

    final medication = day.medications.single;
    expect(day.day, 'monday');
    expect(medication.id, 42);
    expect(medication.quantityPerTime, 2);
    expect(medication.days, ['monday', 'wednesday']);
    expect(medication.times.single.medicationId, 42);
    expect(medication.times.single.status, 'taken');
    expect(medication.imagePath, 'https://example.test/medication/42');
  });
}
