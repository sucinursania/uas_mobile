import 'package:dio/dio.dart';
import '../utils/constant.dart';
import 'storage_service.dart';

/// Layanan pusat untuk konfigurasi HTTP API aplikasi.
/// Menyediakan instance Dio dan header autentikasi yang digunakan oleh layanan lain.
class ApiService {
  /// Instance Dio yang digunakan untuk semua request ke backend.
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  /// Mengambil header request yang mencakup token autentikasi jika tersedia.
  Future<Map<String, String>> getHeaders() async {
    final token = await StorageService.getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null)
        'Authorization': 'Bearer $token',
    };
  }
}