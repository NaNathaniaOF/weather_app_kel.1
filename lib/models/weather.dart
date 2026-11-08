import '../core/format_utils.dart';

/// Model data cuaca hasil parsing JSON endpoint `/data/2.5/weather`.
class Weather {
  const Weather({
    required this.cityName,
    required this.country,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.fetchedAt,
  });

  final String cityName;
  final String country;

  /// Kelompok kondisi, contoh: `Clear`, `Clouds`, `Rain`.
  final String condition;

  /// Deskripsi (bahasa Indonesia karena parameter `lang=id`).
  final String description;
  final String iconCode;

  /// Suhu dalam derajat Celsius.
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;

  /// Kelembapan dalam persen.
  final int humidity;

  /// Tekanan udara dalam hPa.
  final int pressure;

  /// Kecepatan angin dalam meter per detik.
  final double windSpeed;

  /// Waktu data diambil pada perangkat.
  final DateTime fetchedAt;

  /// Kecepatan angin dalam km/jam.
  double get windSpeedKmh => windSpeed * 3.6;

  String get displayName =>
      country.isEmpty ? cityName : '$cityName, $country';

  String get descriptionTitleCase => FormatUtils.titleCase(description);

  /// Membuat objek [Weather] dari JSON.
  ///
  /// Melempar [FormatException] atau [TypeError] bila struktur JSON tidak
  /// sesuai; keduanya ditangani oleh `WeatherService`.
  factory Weather.fromJson(Map<String, dynamic> json, {DateTime? now}) {
    final weatherList = json['weather'] as List<dynamic>;
    if (weatherList.isEmpty) {
      throw const FormatException('Data cuaca kosong.');
    }

    final weather = weatherList.first as Map<String, dynamic>;
    final main = json['main'] as Map<String, dynamic>;
    final wind = (json['wind'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};
    final sys = (json['sys'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};

    return Weather(
      cityName: (json['name'] as String?) ?? 'Tidak diketahui',
      country: (sys['country'] as String?) ?? '',
      condition: (weather['main'] as String?) ?? '',
      description: (weather['description'] as String?) ?? '',
      iconCode: (weather['icon'] as String?) ?? '01d',
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      humidity: (main['humidity'] as num).toInt(),
      pressure: (main['pressure'] as num).toInt(),
      windSpeed: ((wind['speed'] as num?) ?? 0).toDouble(),
      fetchedAt: now ?? DateTime.now(),
    );
  }
}
