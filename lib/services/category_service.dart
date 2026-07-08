import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../utils/constant.dart';

/// Layanan untuk mengambil data kategori produk dari backend.
class CategoryService {
  /// Instance Dio yang digunakan untuk memanggil endpoint kategori.
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Mengambil daftar semua kategori produk yang tersedia.
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get('/categories');

      final List data = response.data['data'];

      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Gagal mengambil kategori',
      );
    }
  }
}
