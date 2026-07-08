import 'package:flutter/material.dart';

/// Widget pencarian produk yang digunakan untuk mencari item berdasarkan kata kunci.
/// Menyediakan input teks dan tombol hapus pencarian.
class ProductSearchBar extends StatelessWidget {
  /// Controller untuk mengelola input pencarian.
  final TextEditingController controller;

  /// Kata kunci pencarian yang sedang dimasukkan pengguna.
  final String searchQuery;

  /// Callback saat pengguna menekan enter atau mengirim pencarian.
  final Function(String) onSearch;

  /// Callback saat tombol hapus pencarian ditekan.
  final VoidCallback onClear;

  const ProductSearchBar({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Cari produk...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: onClear,
              )
            : null,
      ),
      onSubmitted: onSearch,
    );
  }
}
