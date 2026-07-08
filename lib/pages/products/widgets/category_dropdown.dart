import 'package:flutter/material.dart';

import '../../../models/category_model.dart';

/// Widget dropdown untuk memilih kategori produk.
/// Memungkinkan pengguna memfilter daftar produk berdasarkan kategori tertentu.
class CategoryDropdown extends StatelessWidget {
  /// Daftar kategori yang tersedia untuk dipilih.
  final List<CategoryModel> categories;

  /// ID kategori yang sedang dipilih saat ini.
  final String? selectedCategoryId;

  /// Callback yang dipanggil saat pengguna memilih kategori berbeda.
  final Function(String?) onChanged;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedCategoryId,
      decoration: const InputDecoration(labelText: 'Kategori'),
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('Semua')),
        ...categories.map(
          (category) => DropdownMenuItem<String>(
            value: category.id,
            child: Text(category.name, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
