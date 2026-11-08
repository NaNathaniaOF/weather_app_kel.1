import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather.dart';

const String sampleJson = '''
{
  "weather": [
    {"id": 500, "main": "Rain", "description": "hujan ringan", "icon": "10d"}
  ],
  "main": {
    "temp": 29.4,
    "feels_like": 33.1,
    "temp_min": 27.8,
    "temp_max": 30.2,
    "pressure": 1009,
    "humidity": 78
  },
  "wind": {"speed": 3.6},
  "sys": {"country": "ID"},
  "name": "Jakarta",
  "cod": 200
}
''';

void main() {
  group('Weather.fromJson', () {
    test('mem-parsing seluruh field dengan benar', () {
      final json = jsonDecode(sampleJson) as Map<String, dynamic>;
      final weather = Weather.fromJson(json);

      expect(weather.cityName, 'Jakarta');
      expect(weather.country, 'ID');
      expect(weather.condition, 'Rain');
      expect(weather.iconCode, '10d');
      expect(weather.temperature, 29.4);
      expect(weather.humidity, 78);
      expect(weather.pressure, 1009);
      expect(weather.windSpeed, 3.6);
      expect(weather.displayName, 'Jakarta, ID');
      expect(weather.descriptionTitleCase, 'Hujan Ringan');
    });

    test('konversi m/s ke km/jam', () {
      final json = jsonDecode(sampleJson) as Map<String, dynamic>;
      final weather = Weather.fromJson(json);

      expect(weather.windSpeedKmh, closeTo(12.96, 0.001));
    });

    test('nilai angin default 0 bila field wind tidak ada', () {
      final json = jsonDecode(sampleJson) as Map<String, dynamic>;
      json.remove('wind');
      final weather = Weather.fromJson(json);

      expect(weather.windSpeed, 0);
    });

    test('melempar FormatException bila daftar weather kosong', () {
      final json = jsonDecode(sampleJson) as Map<String, dynamic>;
      json['weather'] = <dynamic>[];

      expect(() => Weather.fromJson(json), throwsFormatException);
    });
  });
}
