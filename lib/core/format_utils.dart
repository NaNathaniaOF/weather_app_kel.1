/// Fungsi bantu pemformatan teks sederhana (tanpa paket tambahan).
class FormatUtils {
  const FormatUtils._();

  /// Mengubah huruf pertama setiap kata menjadi kapital.
  /// Contoh: "hujan ringan" menjadi "Hujan Ringan".
  static String titleCase(String text) {
    return text
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Format jam `HH:mm`.
  static String time(DateTime value) {
    final hh = value.hour.toString().padLeft(2, '0');
    final mm = value.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}
