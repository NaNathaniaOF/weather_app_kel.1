import 'package:flutter/material.dart';

/// Kolom input kota beserta tombol cari.
class CitySearchField extends StatelessWidget {
  const CitySearchField({
    super.key,
    required this.controller,
    required this.onSubmit,
    this.errorText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmit;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            textCapitalization: TextCapitalization.words,
            onSubmitted: onSubmit,
            decoration: InputDecoration(
              hintText: 'Cari kota, contoh: Jakarta',
              prefixIcon: const Icon(Icons.location_city_outlined),
              errorText: errorText,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Tooltip(
          message: 'Cari cuaca',
          child: IconButton.filled(
            onPressed: () => onSubmit(controller.text),
            iconSize: 26,
            padding: const EdgeInsets.all(14),
            icon: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}
