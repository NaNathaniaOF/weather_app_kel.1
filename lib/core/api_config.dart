/// Konfigurasi akses ke OpenWeatherMap.
///
/// API key sebaiknya TIDAK ditulis langsung di kode yang di-commit ke GitHub.
/// Berikan melalui argumen build:
///
///   flutter run --dart-define=OPENWEATHER_API_KEY=xxxxxxxx
///
/// Alternatif untuk belajar/lokal: isi `defaultValue` di bawah, lalu jangan
/// di-commit.
class ApiConfig {
  const ApiConfig._();

  static const String apiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: '',
  );

  static const String host = 'api.openweathermap.org';
  static const String weatherPath = '/data/2.5/weather';

  /// Ikon cuaca resmi OpenWeatherMap, contoh kode: `10d`, `01n`.
  static String iconUrl(String iconCode) =>
      'https://openweathermap.org/img/wn/$iconCode@4x.png';
}
