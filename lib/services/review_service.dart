import 'package:dio/dio.dart';

import '../models/review_model.dart';
import '../utils/constant.dart';
import 'storage_service.dart';

/// Layanan untuk mengambil dan menambahkan ulasan produk.
class ReviewService {
  /// Instance Dio yang digunakan untuk memanggil endpoint ulasan.
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Mengambil daftar ulasan untuk produk tertentu.
  Future<List<ReviewModel>> getReviews(String productId) async {
    try {
      final response = await _dio.get('/reviews/product/$productId');
      print(response.data); // Debugging line

      final List data = response.data['data'] as List;

      return data.map((e) => ReviewModel.fromJson(e)).toList();
    } on DioException catch (e) {
      print(e.response?.statusCode); // Debugging line
      print(e.response?.data); // Debugging line
      throw Exception(
        e.response?.data['message'] ?? 'Gagal mengambil ulasan produk.',
      );
    }
  }

  /// Menambahkan ulasan baru untuk produk tertentu.
  Future<void> addReview({
    required String productId,
    required int rating,
    required String comment,
  }) async {
    try {
      final token = await StorageService.getToken();

      await _dio.post(
        '/reviews/product/$productId',
        data: {'rating': rating, 'comment': comment},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Terjadi kesalahan server',
      );
    }
  }
}
