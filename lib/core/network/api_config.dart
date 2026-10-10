/// Konfigurasi backend terpusat.
///
/// Cara pakai saat backend siap:
/// `flutter run --dart-define=API_BASE_URL=https://api.sijalink.id`
abstract class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// True jika URL backend sudah diisi (bukan mode dummy).
  static bool get memakaiBackend => baseUrl.isNotEmpty;

  static const Duration timeout = Duration(seconds: 15);
}
