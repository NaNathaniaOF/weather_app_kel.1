# Cuaca Hari Ini (Real-Time Weather App)

Aplikasi Flutter untuk memantau cuaca langsung di berbagai kota memakai REST API OpenWeatherMap.
Dibuat untuk UTS Pemrograman Mobile Lanjut (INF3022), Kasus 3.

## Fitur

- Pencarian kota dengan input teks (tekan Enter atau tombol cari)
- Menampilkan suhu, suhu terasa, min/maks, kelembapan, kecepatan angin (km/jam dan m/s), tekanan udara
- Ikon visual cuaca dari OpenWeatherMap, dengan ikon cadangan jika gagal dimuat
- Status loading saat data diambil
- Penanganan error: kota tidak ditemukan, tanpa internet, timeout, API key salah, server error, input kosong
- Riwayat 5 kota terakhir (shared_preferences), kota terakhir otomatis dimuat saat aplikasi dibuka
- Tarik ke bawah untuk memperbarui data
- Tema terang dan gelap otomatis, tata letak responsif (ponsel dan tablet)

## Teknologi

Flutter (Dart), paket `http` (REST API), `shared_preferences` (riwayat lokal), `FutureBuilder`, `async/await`, Material 3.

## Struktur Proyek

```
lib/
  main.dart                     titik masuk aplikasi
  core/
    api_config.dart             konfigurasi API (host, path, API key)
    app_theme.dart              tema terang/gelap
    weather_style.dart          warna gradien dan ikon cadangan per kondisi
    format_utils.dart           fungsi bantu format teks dan jam
  models/
    weather.dart                model data + parsing JSON
  services/
    weather_service.dart        pemanggilan REST API + pemetaan error
    weather_exception.dart      exception dan jenis error
    search_history_storage.dart penyimpanan riwayat pencarian
  screens/
    home_screen.dart            layar utama (FutureBuilder)
  widgets/
    city_search_field.dart      input kota
    recent_searches.dart        chip riwayat
    weather_card.dart           kartu cuaca utama
    weather_details.dart        petak detail (kelembapan, angin, dst.)
    state_views.dart            tampilan welcome, loading, error
test/                           unit test model, service, dan widget test
```

## Cara Menjalankan

1. Daftar gratis di https://openweathermap.org/api lalu salin API key (key baru bisa butuh beberapa menit untuk aktif).
2. Buat proyek Flutter dan salin berkas ini:
   ```bash
   flutter create --org id.ac.kampus --project-name weather_app .
   ```
   Lalu timpa folder `lib/`, `test/`, `pubspec.yaml`, dan `analysis_options.yaml` dengan isi repositori ini.
3. Izin internet. Buka `android/app/src/main/AndroidManifest.xml` dan tambahkan di atas tag `<application>`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```
4. Agar sesuai syarat minimal Android 8.0, di `android/app/build.gradle(.kts)` set `minSdk = 26` (atau `minSdkVersion 26`).
5. Pasang dependensi dan jalankan:
   ```bash
   flutter pub get
   flutter run --dart-define=OPENWEATHER_API_KEY=ISI_API_KEY_ANDA
   ```
6. Jalankan pengujian:
   ```bash
   flutter test
   ```
7. Membuat APK:
   ```bash
   flutter build apk --release --dart-define=OPENWEATHER_API_KEY=ISI_API_KEY_ANDA
   ```

Catatan keamanan: jangan commit API key ke GitHub. Gunakan `--dart-define` seperti di atas.

## Anggota Kelompok

| Nama | NIM |
|---|---|
| Nathania Okke Febriantri | 25170003 |
| Jovan Putra Wijaya       | 25170004 |
| Naufal Marzuki Fadhil    | 25170018 |
| Cantika Dwi Utari        | 25170023 |
