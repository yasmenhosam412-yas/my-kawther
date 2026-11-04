class AppConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8010',
  );
  static const logo = 'assets/images/pharmacy_logo.svg';
}
