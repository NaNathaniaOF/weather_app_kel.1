/// Jenis kesalahan yang dapat terjadi saat mengambil data cuaca.
enum WeatherErrorType {
  emptyInput,
  cityNotFound,
  invalidApiKey,
  rateLimited,
  noConnection,
  timeout,
  server,
  unknown,
}

/// Exception khusus aplikasi dengan pesan yang ramah pengguna.
class WeatherException implements Exception {
  const WeatherException(
    this.message, {
    this.type = WeatherErrorType.unknown,
  });

  final String message;
  final WeatherErrorType type;

  @override
  String toString() => 'WeatherException($type): $message';
}
