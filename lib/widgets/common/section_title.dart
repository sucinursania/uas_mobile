import 'package:flutter/material.dart';
import '../../theme/app.dart';

/// Widget judul bagian yang menampilkan judul dan tombol aksi opsional.
class SectionTitle extends StatelessWidget {
  /// Judul yang ditampilkan pada bagian tersebut.
  final String title;

  /// Aksi yang dijalankan saat tombol "Lihat Semua" ditekan.
  final VoidCallback? onTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTheme.heading.copyWith(
            color: AppTheme.textColor(context),
          ),
        ),

        const Spacer(),

        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              "Lihat Semua",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}