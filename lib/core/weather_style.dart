import 'package:flutter/material.dart';

/// Gaya visual (warna latar dan ikon cadangan) berdasarkan kondisi cuaca.
///
/// Nilai [condition] mengikuti field `weather[0].main` dari OpenWeatherMap,
/// misalnya `Clear`, `Clouds`, `Rain`, `Thunderstorm`.
class WeatherStyle {
  const WeatherStyle._();

  /// Gradien latar kartu cuaca. Semua warna cukup gelap agar teks putih
  /// tetap terbaca (kontras baik).
  static List<Color> gradientFor(String condition) {
    switch (condition) {
      case 'Clear':
        return const [Color(0xFF2F80ED), Color(0xFF56CCF2)];
      case 'Clouds':
        return const [Color(0xFF4B5C7A), Color(0xFF8493B0)];
      case 'Rain':
      case 'Drizzle':
        return const [Color(0xFF2C3E63), Color(0xFF4A6FA5)];
      case 'Thunderstorm':
        return const [Color(0xFF1F2430), Color(0xFF4B4F6B)];
      case 'Snow':
        return const [Color(0xFF3E5C85), Color(0xFF7FA3C9)];
      default: // Mist, Haze, Fog, Smoke, Dust, dll.
        return const [Color(0xFF485563), Color(0xFF6D7F90)];
    }
  }

  /// Ikon lokal sebagai cadangan jika ikon dari server gagal dimuat.
  static IconData iconFor(String condition) {
    switch (condition) {
      case 'Clear':
        return Icons.wb_sunny_rounded;
      case 'Clouds':
        return Icons.cloud_rounded;
      case 'Rain':
      case 'Drizzle':
        return Icons.water_drop_rounded;
      case 'Thunderstorm':
        return Icons.thunderstorm_rounded;
      case 'Snow':
        return Icons.ac_unit_rounded;
      default:
        return Icons.blur_on_rounded;
    }
  }
}
