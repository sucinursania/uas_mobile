import 'package:dio/dio.dart';
import '../utils/constant.dart';
import 'storage_service.dart';
import 'api_service.dart';

/// Layanan untuk menangani proses autentikasi pengguna, seperti register, login, dan profil.
class AuthService {
  /// Instance Dio yang digunakan untuk memanggil endpoint autentikasi.
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Mendaftarkan pengguna baru ke sistem.
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {"full_name": fullName, "email": email, "password": password},
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Register gagal');
    }
  }

  /// Melakukan login pengguna dan menyimpan token akses.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {"email": email, "password": password},
      );

      final token = response.data['data']['access_token'];

      await StorageService.saveToken(token);

      return token;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login gagal');
    }
  }

  /// Mengambil data profil pengguna yang sedang login.
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final headers = await ApiService().getHeaders();

      final response = await _dio.get(
        '/auth/profile',
        options: Options(headers: headers),
      );

      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Gagal mengambil data profil',
      );
    }
  }

  /// Memperbarui data profil pengguna seperti nama lengkap dan nomor telepon.
  Future<void> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    try {
      final headers = await ApiService().getHeaders();

      final response = await _dio.put(
        '/auth/profile',
        data: {"full_name": fullName, "phone": phone},
        options: Options(headers: headers),
      );

      print("========== UPDATE PROFILE ==========");
      print("STATUS CODE : ${response.statusCode}");
      print("RESPONSE    : ${response.data}");
      print("====================================");
    } on DioException catch (e) {
      print("========== UPDATE PROFILE ERROR ==========");
      print("STATUS CODE : ${e.response?.statusCode}");
      print("RESPONSE    : ${e.response?.data}");
      print("MESSAGE     : ${e.message}");
      print("==========================================");

      throw Exception(e.response?.data.toString() ?? 'Gagal mengupdate profil');
    }
  }

  /// Menghapus token autentikasi pengguna dari penyimpanan lokal.
  Future<void> logout() async {
    await StorageService.removeToken();
  }
}
