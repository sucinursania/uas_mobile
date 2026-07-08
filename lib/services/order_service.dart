import 'package:dio/dio.dart';

import '../utils/constant.dart';
import 'storage_service.dart';
import '../models/order_model.dart';

/// Layanan untuk mengelola pesanan pengguna, termasuk melihat riwayat dan membuat pesanan baru.
class OrderService {
  /// Instance Dio yang digunakan untuk memanggil endpoint pesanan.
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Mengambil daftar pesanan pengguna.
  Future<List<OrderModel>> getOrders({int page = 1, int limit = 10}) async {
    try {
      final token = await StorageService.getToken();

      final response = await _dio.get(
        '/orders',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List data = response.data['data'];

      return data.map((e) => OrderModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Gagal mengambil daftar pesanan',
      );
    }
  }

  /// Mengambil detail satu pesanan berdasarkan ID pesanan.
  Future<OrderModel> getOrderDetail(String id) async {
    try {
      final token = await StorageService.getToken();

      final response = await _dio.get(
        '/orders/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return OrderModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Gagal mengambil detail pesanan',
      );
    }
  }

  /// Membuat pesanan baru berdasarkan alamat pengiriman dan catatan tambahan.
  Future<void> createOrder({
    required String shippingAddress,
    String? notes,
  }) async {
    final token = await StorageService.getToken();

    await _dio.post(
      '/orders',
      data: {'shipping_address': shippingAddress, 'notes': notes},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
