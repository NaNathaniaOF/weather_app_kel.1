import 'package:flutter/material.dart';

import '../core/api_config.dart';
import '../core/format_utils.dart';
import '../core/weather_style.dart';
import '../models/weather.dart';

/// Kartu utama: nama kota, ikon, suhu, dan deskripsi cuaca.
class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final colors = WeatherStyle.gradientFor(weather.condition);

    return Semantics(
      label: 'Cuaca ${weather.displayName}, ${weather.temperature.round()} '
          'derajat Celsius, ${weather.description}',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: colors.first.withAlpha(90),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    weather.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Diperbarui pukul ${FormatUtils.time(weather.fetchedAt)}',
              style: TextStyle(color: Colors.white.withAlpha(200)),
            ),
            const SizedBox(height: 8),
            _WeatherIcon(weather: weather),
            Text(
              '${weather.temperature.round()}°C',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 72,
                fontWeight: FontWeight.w300,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              weather.descriptionTitleCase,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Min ${weather.tempMin.round()}°  •  '
              'Maks ${weather.tempMax.round()}°',
              style: TextStyle(color: Colors.white.withAlpha(220)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({required this.weather});

  final Weather weather;

  static const double _size = 120;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      ApiConfig.iconUrl(weather.iconCode),
      width: _size,
      height: _size,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const SizedBox(
          width: _size,
          height: _size,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        );
      },
      // Jika ikon dari server gagal dimuat, pakai ikon lokal.
      errorBuilder: (context, error, stackTrace) => SizedBox(
        width: _size,
        height: _size,
        child: Icon(
          WeatherStyle.iconFor(weather.condition),
          size: 88,
          color: Colors.white,
        ),
      ),
    );
  }
}
