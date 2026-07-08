import 'package:flutter/material.dart';

import '../../theme/app.dart';

/// Widget tampilan kosong yang digunakan saat data belum tersedia.
/// Menampilkan ikon, judul, dan deskripsi singkat untuk state kosong.
class AppEmpty extends StatelessWidget {
  /// Ikon yang ditampilkan untuk mewakili state kosong.
  final IconData icon;

  /// Judul utama yang menjelaskan kondisi kosong.
  final String title;

  /// Penjelasan tambahan untuk membantu pengguna memahami situasi.
  final String subtitle;

  const AppEmpty({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              size: 70,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            Text(
              title,
              style: AppTheme.heading,
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTheme.body,
            )

          ],
        ),
      ),
    );
  }
}