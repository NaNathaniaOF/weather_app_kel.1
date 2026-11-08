import 'package:flutter/material.dart';

/// Daftar chip kota yang baru dicari, dapat diketuk untuk mencari ulang.
class RecentSearches extends StatelessWidget {
  const RecentSearches({
    super.key,
    required this.cities,
    required this.onSelected,
    required this.onClear,
  });

  final List<String> cities;
  final ValueChanged<String> onSelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (cities.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Pencarian terakhir', style: textTheme.labelLarge),
            const Spacer(),
            TextButton(onPressed: onClear, child: const Text('Hapus')),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final city in cities)
              ActionChip(
                avatar: const Icon(Icons.history, size: 18),
                label: Text(city),
                onPressed: () => onSelected(city),
              ),
          ],
        ),
      ],
    );
  }
}
