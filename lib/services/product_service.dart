import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../utils/constant.dart';

/// Layanan untuk mengambil data produk dari backend.
class ProductService {
  /// Instance Dio yang digunakan untuk memanggil endpoint produk.
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Mengambil daftar produk dengan opsi pencarian, filter kategori, dan urutan.
  Future<List<ProductModel>> getProducts({
    int page = 1,
    String search = '',
    String? categoryId,
    String? sort,
  }) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          'page': page,
          if (search.isNotEmpty) 'search': search,
          if (categoryId != null) 'category_id': categoryId,
          if (sort != null) 'sort': sort,
        },
      );

      final List data = response.data['data'];

      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil produk');
    }
  }

  /// Mengambil detail satu produk berdasarkan ID produk.
  Future<ProductModel> getProductDetail(String id) async {
    try {
      final response = await _dio.get('/products/$id');

      return ProductModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Gagal mengambil detail produk',
      );
    }
  }
}
