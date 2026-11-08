import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan riwayat kota yang pernah dicari di penyimpanan lokal perangkat.
class SearchHistoryStorage {
  const SearchHistoryStorage();

  static const String _key = 'recent_cities';
  static const int _maxItems = 5;

  Future<List<String>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_key) ?? <String>[];
    } catch (_) {
      return <String>[];
    }
  }

  /// Menambahkan [city] ke urutan teratas (tanpa duplikat) dan
  /// mengembalikan daftar terbaru.
  Future<List<String>> add(String city) async {
    final current = await load();
    final updated = <String>[
      city,
      ...current.where((c) => c.toLowerCase() != city.toLowerCase()),
    ].take(_maxItems).toList();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_key, updated);
    } catch (_) {
      // Gagal menyimpan riwayat tidak boleh mengganggu fitur utama.
    }
    return updated;
  }

  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (_) {}
  }
}
