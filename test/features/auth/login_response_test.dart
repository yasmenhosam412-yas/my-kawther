import 'package:elkawther/features/auth/models/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginResponse.fromJson', () {
    test('parses the API login response', () {
      final response = LoginResponse.fromJson({
        'token': 'access-token',
        'user': {
          'id': 42,
          'name': 'Test User',
          'email': 'test@example.com',
          'phone': '01000000000',
        },
      });

      expect(response.token, 'access-token');
      expect(response.userId, 42);
      expect(response.userName, 'Test User');
      expect(response.email, 'test@example.com');
      expect(response.phone, '01000000000');
    });

    test('rejects a response without a token', () {
      expect(
        () => LoginResponse.fromJson({'user': {'id': 42}}),
        throwsFormatException,
      );
    });
  });
}
