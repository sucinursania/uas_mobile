import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider yang mengelola status tema aplikasi, baik mode terang maupun gelap.
/// Menyimpan preferensi tema ke SharedPreferences agar tetap tersimpan antar sesi.
class ThemeProvider extends ChangeNotifier {
  /// Menyimpan status apakah tema gelap sedang aktif.
  bool _isDarkMode = false;

  /// Getter untuk mengakses status tema saat ini.
  bool get isDarkMode => _isDarkMode;

  /// Memuat preferensi tema yang tersimpan sebelumnya dari penyimpanan lokal.
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    notifyListeners();
  }

  /// Mengubah tema aplikasi dan menyimpan preferensi ke penyimpanan lokal.
  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);

    notifyListeners();
  }
}