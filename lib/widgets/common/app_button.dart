import 'package:flutter/material.dart';

/// Widget tombol aplikasi yang konsisten dengan desain umum.
/// Digunakan untuk tombol aksi utama dengan dukungan loading dan ikon opsional.
class AppButton extends StatelessWidget {
  /// Teks yang ditampilkan pada tombol.
  final String text;

  /// Aksi yang dijalankan saat tombol ditekan.
  final VoidCallback? onPressed;

  /// Menandakan apakah tombol sedang dalam proses loading.
  final bool loading;

  /// Ikon opsional yang ditampilkan di depan teks tombol.
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}