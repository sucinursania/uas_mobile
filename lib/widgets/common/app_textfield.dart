import 'package:flutter/material.dart';

import '../../theme/app.dart';

/// Widget input teks yang digunakan secara konsisten di seluruh aplikasi.
/// Menyediakan hint, ikon, validasi, dan opsi tampilan seperti password.
class AppTextField extends StatelessWidget {
  /// Controller yang mengatur nilai input teks.
  final TextEditingController controller;

  /// Teks petunjuk yang muncul di dalam field.
  final String hint;

  /// Ikon yang ditampilkan di bagian kiri input.
  final IconData icon;

  /// Menyembunyikan teks saat nilai merupakan password.
  final bool obscureText;

  /// Ikon tambahan di bagian kanan field.
  final Widget? suffixIcon;

  /// Jenis keyboard yang digunakan untuk input.
  final TextInputType keyboardType;

  /// Fungsi validasi untuk memeriksa nilai input.
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Widget label teks sederhana untuk memberi penjelasan di atas field input.
class AppLabel extends StatelessWidget {
  /// Teks yang ditampilkan sebagai label.
  final String text;

  const AppLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTheme.heading.copyWith(
          fontSize: 15,
        ),
      ),
    );
  }
}