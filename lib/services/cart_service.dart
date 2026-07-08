import 'package:dio/dio.dart';

import '../models/cart_model.dart';
import '../utils/constant.dart';
import 'storage_service.dart';

/// Layanan untuk mengelola keranjang belanja pengguna.
/// Menyediakan operasi menambah, melihat, mengubah, menghapus, dan mengosongkan keranjang.
class CartService {
  /// Instance Dio yang digunakan untuk memanggil endpoint keranjang.
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Menambahkan produk ke keranjang belanja pengguna.
  Future<void> addToCart({required String productId, int quantity = 1}) async {
    try {
      final token = await StorageService.getToken();

      await _dio.post(
        '/cart',
        data: {'product_id': productId, 'quantity': quantity},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Gagal menambahkan ke keranjang',
      );
    }
  }

  /// Mengambil data keranjang pengguna beserta seluruh item di dalamnya.
  Future<CartModel> getCart() async {
    final token = await StorageService.getToken();

    final response = await _dio.get(
      '/cart',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return CartModel.fromJson(response.data['data']);
  }

  /// Mengubah jumlah item tertentu pada keranjang.
  Future<void> updateCart(String id, int quantity) async {
    final token = await StorageService.getToken();

    await _dio.put(
      '/cart/$id',
      data: {'quantity': quantity},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  /// Menghapus satu item dari keranjang berdasarkan ID item.
  Future<void> deleteItem(String id) async {
    final token = await StorageService.getToken();

    await _dio.delete(
      '/cart/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  /// Menghapus semua item dari keranjang pengguna.
  Future<void> clearCart() async {
    final token = await StorageService.getToken();

    await _dio.delete(
      '/cart',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
