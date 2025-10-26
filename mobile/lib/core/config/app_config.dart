class AppConfig {
  // Android emulator dùng 10.0.2.2
  static const String baseUrl = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://10.0.2.2:8080',
  );
}
