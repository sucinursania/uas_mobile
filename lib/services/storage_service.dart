import 'package:shared_preferences/shared_preferences.dart';

/// Layanan untuk menyimpan data sederhana secara lokal menggunakan SharedPreferences.
/// Saat ini digunakan untuk menyimpan token autentikasi pengguna.
class StorageService {
  /// Kunci penyimpanan untuk token akses pengguna.
  static const String tokenKey = 'access_token';

  /// Menyimpan token akses ke penyimpanan lokal.
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  /// Mengambil token akses yang tersimpan dari penyimpanan lokal.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  /// Menghapus token akses dari penyimpanan lokal.
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }
}
