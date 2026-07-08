import 'package:hive/hive.dart';

/// Layanan untuk mengelola daftar produk favorit pengguna menggunakan Hive.
class WishlistService {
  /// Kotak penyimpanan lokal untuk menyimpan daftar wishlist.
  static final Box wishlistBox = Hive.box('wishlist');

  /// Menambahkan produk ke daftar favorit pengguna.
  static Future<void> add({
    required String id,
    required String name,
    required int price,
    required String imageUrl,
  }) async {
    await wishlistBox.put(id, {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    });
  }

  /// Menghapus produk dari daftar favorit berdasarkan ID produk.
  static Future<void> remove(String id) async {
    await wishlistBox.delete(id);
  }

  /// Mengecek apakah suatu produk saat ini ada di daftar favorit.
  static bool isFavorite(String id) {
    return wishlistBox.containsKey(id);
  }

  /// Mengambil seluruh daftar produk favorit yang tersimpan.
  static List<Map<String, dynamic>> getAll() {
    return wishlistBox.values
        .where((e) => e is Map)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}