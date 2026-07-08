import 'package:flutter/material.dart';

import '../../theme/app.dart';

/// Widget header halaman yang menampilkan judul, subjudul, dan tombol kembali.
class PageHeader extends StatelessWidget {
  /// Judul utama yang ditampilkan di bagian atas halaman.
  final String title;

  /// Penjelasan singkat di bawah judul halaman.
  final String subtitle;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: 22,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),

        const SizedBox(height: 28),

        Text(
          title,
          style: AppTheme.title,
        ),

        const SizedBox(height: 10),

        Text(
          subtitle,
          style: AppTheme.body,
        ),

      ],
    );
  }
}