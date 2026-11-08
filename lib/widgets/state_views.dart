import 'package:flutter/material.dart';

import '../services/weather_exception.dart';

/// Tampilan saat belum ada pencarian.
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MessageView(
      icon: Icons.wb_cloudy_outlined,
      title: 'Cari cuaca kota mana pun',
      message: 'Ketik nama kota pada kolom di atas, '
          'lalu tekan tombol cari.',
    );
  }
}

/// Tampilan saat data sedang dimuat.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Mengambil data cuaca...'),
        ],
      ),
    );
  }
}

/// Tampilan saat terjadi kesalahan, lengkap dengan tombol coba lagi.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final err = error;
    final exception = err is WeatherException ? err : null;
    final type = exception?.type ?? WeatherErrorType.unknown;
    final message =
        exception?.message ?? 'Terjadi kesalahan yang tidak terduga.';

    return _MessageView(
      icon: _iconFor(type),
      title: _titleFor(type),
      message: message,
      isError: true,
      action: type == WeatherErrorType.emptyInput
          ? null
          : FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
    );
  }

  static IconData _iconFor(WeatherErrorType type) {
    switch (type) {
      case WeatherErrorType.cityNotFound:
        return Icons.search_off;
      case WeatherErrorType.noConnection:
        return Icons.wifi_off;
      case WeatherErrorType.timeout:
        return Icons.timer_off_outlined;
      case WeatherErrorType.invalidApiKey:
        return Icons.vpn_key_off_outlined;
      default:
        return Icons.error_outline;
    }
  }

  static String _titleFor(WeatherErrorType type) {
    switch (type) {
      case WeatherErrorType.cityNotFound:
        return 'Kota tidak ditemukan';
      case WeatherErrorType.noConnection:
        return 'Tidak ada koneksi';
      case WeatherErrorType.timeout:
        return 'Waktu habis';
      case WeatherErrorType.invalidApiKey:
        return 'Masalah API key';
      case WeatherErrorType.emptyInput:
        return 'Input kosong';
      default:
        return 'Gagal memuat cuaca';
    }
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.title,
    required this.message,
    this.isError = false,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool isError;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = isError ? scheme.error : scheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Column(
        children: [
          Icon(icon, size: 72, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: 20),
            action!,
          ],
        ],
      ),
    );
  }
}
