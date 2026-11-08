import 'package:flutter/material.dart';

import '../models/weather.dart';

/// Petak informasi tambahan: kelembapan, angin, tekanan, suhu terasa.
///
/// Jumlah kolom menyesuaikan lebar layar (2 kolom pada ponsel,
/// 4 kolom pada layar lebar/tablet) agar tetap responsif.
class WeatherDetails extends StatelessWidget {
  const WeatherDetails({super.key, required this.weather});

  final Weather weather;

  static const double _spacing = 12;

  @override
  Widget build(BuildContext context) {
    final tiles = <_InfoTile>[
      _InfoTile(
        icon: Icons.water_drop_outlined,
        label: 'Kelembapan',
        value: '${weather.humidity}%',
      ),
      _InfoTile(
        icon: Icons.air,
        label: 'Kecepatan angin',
        value: '${weather.windSpeedKmh.toStringAsFixed(1)} km/jam',
        subtitle: '${weather.windSpeed.toStringAsFixed(1)} m/s',
      ),
      _InfoTile(
        icon: Icons.speed_outlined,
        label: 'Tekanan udara',
        value: '${weather.pressure} hPa',
      ),
      _InfoTile(
        icon: Icons.thermostat_outlined,
        label: 'Terasa seperti',
        value: '${weather.feelsLike.round()}°C',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 4 : 2;
        final tileWidth =
            (constraints.maxWidth - _spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: _spacing,
          runSpacing: _spacing,
          children: [
            for (final tile in tiles) SizedBox(width: tileWidth, child: tile),
          ],
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: 12),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
