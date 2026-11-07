class AppConstants {
  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.3:8000',
  );
  static const String baseUrl = _configuredBaseUrl;
  static const logo = 'assets/images/pharmacy_logo.svg';
}
