import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:weather_app/services/weather_exception.dart';
import 'package:weather_app/services/weather_service.dart';

import 'weather_model_test.dart' show sampleJson;

WeatherService buildService(MockClientHandler handler, {String key = 'test'}) {
  return WeatherService(client: MockClient(handler), apiKey: key);
}

Matcher throwsWeatherError(WeatherErrorType type) {
  return throwsA(
    isA<WeatherException>().having((e) => e.type, 'type', type),
  );
}

void main() {
  group('WeatherService.fetchByCity', () {
    test('sukses: mengirim parameter yang benar dan mengembalikan Weather',
        () async {
      late Uri requested;
      final service = buildService((request) async {
        requested = request.url;
        return http.Response(sampleJson, 200);
      });

      final weather = await service.fetchByCity('  Jakarta ');

      expect(weather.cityName, 'Jakarta');
      expect(requested.host, 'api.openweathermap.org');
      expect(requested.queryParameters['q'], 'Jakarta');
      expect(requested.queryParameters['units'], 'metric');
      expect(requested.queryParameters['appid'], 'test');
    });

    test('input kosong ditolak tanpa memanggil jaringan', () async {
      var called = false;
      final service = buildService((request) async {
        called = true;
        return http.Response(sampleJson, 200);
      });

      await expectLater(
        service.fetchByCity('   '),
        throwsWeatherError(WeatherErrorType.emptyInput),
      );
      expect(called, isFalse);
    });

    test('404 menjadi cityNotFound', () async {
      final service = buildService((request) async {
        return http.Response('{"cod":"404","message":"city not found"}', 404);
      });

      await expectLater(
        service.fetchByCity('Kotaabcxyz'),
        throwsWeatherError(WeatherErrorType.cityNotFound),
      );
    });

    test('401 menjadi invalidApiKey', () async {
      final service = buildService((request) async {
        return http.Response('{"cod":401}', 401);
      });

      await expectLater(
        service.fetchByCity('Jakarta'),
        throwsWeatherError(WeatherErrorType.invalidApiKey),
      );
    });

    test('API key kosong menjadi invalidApiKey', () async {
      final service = buildService(
        (request) async => http.Response(sampleJson, 200),
        key: '',
      );

      await expectLater(
        service.fetchByCity('Jakarta'),
        throwsWeatherError(WeatherErrorType.invalidApiKey),
      );
    });

    test('500 menjadi server error', () async {
      final service = buildService((request) async {
        return http.Response('error', 503);
      });

      await expectLater(
        service.fetchByCity('Jakarta'),
        throwsWeatherError(WeatherErrorType.server),
      );
    });

    test('ClientException menjadi noConnection', () async {
      final service = buildService((request) async {
        throw http.ClientException('Failed host lookup');
      });

      await expectLater(
        service.fetchByCity('Jakarta'),
        throwsWeatherError(WeatherErrorType.noConnection),
      );
    });

    test('JSON rusak menjadi unknown', () async {
      final service = buildService((request) async {
        return http.Response('<html>bukan json</html>', 200);
      });

      await expectLater(
        service.fetchByCity('Jakarta'),
        throwsWeatherError(WeatherErrorType.unknown),
      );
    });
  });
}
