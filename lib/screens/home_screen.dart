import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/search_history_storage.dart';
import '../services/weather_service.dart';
import '../widgets/city_search_field.dart';
import '../widgets/recent_searches.dart';
import '../widgets/state_views.dart';
import '../widgets/weather_card.dart';
import '../widgets/weather_details.dart';

/// Layar utama: pencarian kota dan tampilan hasil cuaca.
///
/// Memakai [FutureBuilder] untuk memetakan tiga keadaan Future
/// (loading, error, sukses) ke tampilan yang sesuai.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.service,
    this.storage = const SearchHistoryStorage(),
  });

  /// Dapat disuntikkan dari luar (berguna untuk pengujian).
  final WeatherService? service;
  final SearchHistoryStorage storage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WeatherService _service;
  late final bool _ownsService;
  final TextEditingController _controller = TextEditingController();

  Future<Weather>? _weatherFuture;
  List<String> _recent = <String>[];
  String? _lastQuery;
  String? _inputError;

  @override
  void initState() {
    super.initState();
    _ownsService = widget.service == null;
    _service = widget.service ?? WeatherService();
    _restoreHistory();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_ownsService) _service.dispose();
    super.dispose();
  }

  /// Memuat riwayat pencarian, lalu otomatis menampilkan kota terakhir.
  Future<void> _restoreHistory() async {
    final history = await widget.storage.load();
    if (!mounted) return;
    setState(() => _recent = history);
    if (history.isNotEmpty) {
      _controller.text = history.first;
      _search(history.first);
    }
  }

  void _search(String input) {
    final query = input.trim();

    if (query.isEmpty) {
      setState(() => _inputError = 'Nama kota tidak boleh kosong.');
      return;
    }

    FocusScope.of(context).unfocus();

    // `ignore()` menandai error pada Future ini sebagai sudah ditangani,
    // sehingga tidak dilaporkan sebagai error tak tertangani sebelum
    // FutureBuilder mulai mendengarkan. FutureBuilder tetap menerima error-nya.
    final future = _fetch(query)..ignore();
    setState(() {
      _inputError = null;
      _lastQuery = query;
      _weatherFuture = future;
    });
  }

  Future<Weather> _fetch(String query) async {
    final weather = await _service.fetchByCity(query);
    final updated = await widget.storage.add(weather.cityName);
    if (mounted) setState(() => _recent = updated);
    return weather;
  }

  Future<void> _refresh() async {
    final query = _lastQuery;
    if (query == null) return;

    final future = _fetch(query)..ignore();
    setState(() => _weatherFuture = future);
    try {
      await future;
    } catch (_) {
      // Error sudah ditampilkan oleh FutureBuilder.
    }
  }

  Future<void> _clearHistory() async {
    await widget.storage.clear();
    if (mounted) setState(() => _recent = <String>[]);
  }

  void _selectRecent(String city) {
    _controller.text = city;
    _search(city);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          // Batasi lebar agar tetap rapi di tablet/layar lebar.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                children: [
                  Text(
                    'Cuaca Hari Ini',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pantau kondisi cuaca langsung di berbagai kota.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CitySearchField(
                    controller: _controller,
                    onSubmit: _search,
                    errorText: _inputError,
                  ),
                  const SizedBox(height: 8),
                  RecentSearches(
                    cities: _recent,
                    onSelected: _selectRecent,
                    onClear: _clearHistory,
                  ),
                  const SizedBox(height: 16),
                  _buildResult(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    if (_weatherFuture == null) return const WelcomeView();

    return FutureBuilder<Weather>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView();
        }
        if (snapshot.hasError) {
          return ErrorView(
            error: snapshot.error,
            onRetry: () => _search(_lastQuery ?? ''),
          );
        }
        if (snapshot.hasData) {
          final weather = snapshot.data!;
          return Column(
            children: [
              WeatherCard(weather: weather),
              const SizedBox(height: 16),
              WeatherDetails(weather: weather),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
