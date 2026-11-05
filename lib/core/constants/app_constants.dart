import 'package:flutter/foundation.dart';

class AppConstants {
  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );
  static final String baseUrl =
      _configuredBaseUrl.isNotEmpty
          ? _configuredBaseUrl
          : defaultTargetPlatform == TargetPlatform.android
          ? 'http://192.168.1.3:8081/'
          : 'http://192.168.1.3:8081';
  static const logo = 'assets/images/pharmacy_logo.svg';
}
