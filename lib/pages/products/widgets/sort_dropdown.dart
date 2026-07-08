import 'package:flutter/material.dart';

/// Widget dropdown untuk mengurutkan daftar produk.
/// Memungkinkan pengguna memilih metode pengurutan seperti termurah, termahal, atau terbaru.
class SortDropdown extends StatelessWidget {
  /// Opsi pengurutan yang sedang dipilih pengguna.
  final String? selectedSort;

  /// Callback saat pengguna memilih opsi pengurutan lain.
  final Function(String?) onChanged;

  const SortDropdown({
    super.key,
    required this.selectedSort,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedSort,
      decoration: const InputDecoration(labelText: 'Urutkan'),
      items: const [
        DropdownMenuItem(value: 'price_asc', child: Text('Termurah')),
        DropdownMenuItem(value: 'price_desc', child: Text('Termahal')),
        DropdownMenuItem(value: 'newest', child: Text('Terbaru')),
      ],
      onChanged: onChanged,
    );
  }
}
