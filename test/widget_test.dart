import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/services/weather_service.dart';

import 'weather_model_test.dart' show sampleJson;

Widget buildApp(MockClientHandler handler) {
  return MaterialApp(
    home: HomeScreen(
      service: WeatherService(client: MockClient(handler), apiKey: 'test'),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('menampilkan layar sambutan saat pertama dibuka',
      (tester) async {
    await tester.pumpWidget(
      buildApp((request) async => http.Response(sampleJson, 200)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cari cuaca kota mana pun'), findsOneWidget);
  });

  testWidgets('input kosong menampilkan pesan validasi', (tester) async {
    await tester.pumpWidget(
      buildApp((request) async => http.Response(sampleJson, 200)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    expect(find.text('Nama kota tidak boleh kosong.'), findsOneWidget);
  });

  testWidgets('kota tidak ditemukan menampilkan pesan error', (tester) async {
    await tester.pumpWidget(
      buildApp((request) async => http.Response('{"cod":"404"}', 404)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Kotaabcxyz');
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('Kota tidak ditemukan'), findsOneWidget);
    expect(find.text('Coba lagi'), findsOneWidget);
  });

  testWidgets('pencarian sukses menampilkan suhu dan kelembapan',
      (tester) async {
    await tester.pumpWidget(
      buildApp((request) async => http.Response(sampleJson, 200)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Jakarta');
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('29°C'), findsOneWidget);
    expect(find.text('78%'), findsOneWidget);
    expect(find.text('Hujan Ringan'), findsOneWidget);
  });
}
