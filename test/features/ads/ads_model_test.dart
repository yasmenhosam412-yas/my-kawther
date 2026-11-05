import 'package:elkawther/features/ads/models/ads_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses opening ad fields returned by the API', () {
    final ad = AdsModel.fromJson({
      'id': 12,
      'image_url': 'http://example.com/ad.jpg',
      'is_active': 1,
      'title': 'Welcome',
      'content': 'Special offer',
      'link': 'https://example.com',
      'display_frequency': 'once_per_day',
    });

    expect(ad.id, 12);
    expect(ad.imageUrl, 'http://example.com/ad.jpg');
    expect(ad.isActive, isTrue);
    expect(ad.title, 'Welcome');
    expect(ad.content, 'Special offer');
    expect(ad.link, 'https://example.com');
    expect(ad.displayFrequency, 'once_per_day');
  });
}
