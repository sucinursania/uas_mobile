import 'package:flutter/material.dart';

/// Widget indikator loading yang digunakan saat data sedang dimuat.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}