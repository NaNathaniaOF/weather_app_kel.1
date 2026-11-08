import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../models/weather.dart';
import 'weather_exception.dart';

/// Lapisan akses data (REST API OpenWeatherMap).
///
/// Seluruh kesalahan jaringan, HTTP, dan parsing diubah menjadi
/// [WeatherException] sehingga UI cukup menampilkan `message`.
class WeatherService {
  WeatherService({
    http.Client? client,
    String apiKey = ApiConfig.apiKey,
  })  : _client = client ?? http.Client(),
        _apiKey = apiKey;

  final http.Client _client;
  final String _apiKey;

  static const Duration _timeout = Duration(seconds: 10);

  /// Mengambil cuaca terkini berdasarkan nama kota.
  Future<Weather> fetchByCity(String city) async {
    final query = city.trim();

    if (query.isEmpty) {
      throw const WeatherException(
        'Nama kota tidak boleh kosong.',
        type: WeatherErrorType.emptyInput,
      );
    }
    if (_apiKey.isEmpty) {
      throw const WeatherException(
        'API key belum diisi. Jalankan aplikasi dengan '
        '--dart-define=OPENWEATHER_API_KEY=KEY_ANDA.',
        type: WeatherErrorType.invalidApiKey,
      );
    }

    final uri = Uri.https(ApiConfig.host, ApiConfig.weatherPath, {
      'q': query,
      'appid': _apiKey,
      'units': 'metric', // suhu dalam Celsius
      'lang': 'id', // deskripsi bahasa Indonesia
    });

    try {
      final response = await _client.get(uri).timeout(_timeout);
      return _parseResponse(response, query);
    } on SocketException {
      throw const WeatherException(
        'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
        type: WeatherErrorType.noConnection,
      );
    } on http.ClientException {
      throw const WeatherException(
        'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
        type: WeatherErrorType.noConnection,
      );
    } on TimeoutException {
      throw const WeatherException(
        'Server terlalu lama merespons. Silakan coba lagi.',
        type: WeatherErrorType.timeout,
      );
    } on FormatException {
      throw const WeatherException(
        'Format data dari server tidak dikenali.',
        type: WeatherErrorType.unknown,
      );
    } on TypeError {
      throw const WeatherException(
        'Data dari server tidak lengkap.',
        type: WeatherErrorType.unknown,
      );
    }
  }

  Weather _parseResponse(http.Response response, String query) {
    switch (response.statusCode) {
      case 200:
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return Weather.fromJson(decoded);
      case 401:
        throw const WeatherException(
          'API key tidak valid atau belum aktif. '
          'Key baru OpenWeatherMap bisa butuh beberapa menit untuk aktif.',
          type: WeatherErrorType.invalidApiKey,
        );
      case 404:
        throw WeatherException(
          'Kota "$query" tidak ditemukan. Periksa penulisan nama kota.',
          type: WeatherErrorType.cityNotFound,
        );
      case 429:
        throw const WeatherException(
          'Terlalu banyak permintaan. Tunggu sebentar lalu coba lagi.',
          type: WeatherErrorType.rateLimited,
        );
      default:
        if (response.statusCode >= 500) {
          throw const WeatherException(
            'Server cuaca sedang bermasalah. Coba lagi nanti.',
            type: WeatherErrorType.server,
          );
        }
        throw WeatherException(
          'Terjadi kesalahan (kode ${response.statusCode}).',
          type: WeatherErrorType.unknown,
        );
    }
  }

  void dispose() => _client.close();
}
