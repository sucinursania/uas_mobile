import 'package:flutter/material.dart';
import '../../services/wishlist_service.dart';
import 'package:intl/intl.dart';

/// Halaman wishlist yang menampilkan produk favorit pengguna.
/// Memungkinkan pengguna melihat daftar favorit dan menghapus item dari wishlist.
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  /// Daftar produk favorit yang sedang ditampilkan.
  List<Map<String, dynamic>> wishlist = [];

  /// Formatter untuk menampilkan harga produk dalam format rupiah.
  final NumberFormat rupiah = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

  /// Memuat daftar wishlist saat halaman pertama kali dibuka.
  @override
  void initState() {
    super.initState();
    loadWishlist();
  }

  /// Mengambil daftar produk favorit dari penyimpanan layanan wishlist.
  void loadWishlist() {
    wishlist = WishlistService.getAll();
    setState(() {});
  }

  /// Menghapus satu produk dari wishlist berdasarkan ID produk.
  Future<void> removeItem(String id) async {
    await WishlistService.remove(id);
    loadWishlist();
  }

  @override
  @override
Widget build(BuildContext context) {
  wishlist = WishlistService.getAll();

  return Scaffold(
    appBar: AppBar(
      title: const Text("Wishlist"),
    ),
    body: wishlist.isEmpty
        ? const Center(
            child: Text("Belum ada produk favorit"),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              final item = wishlist[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.shopping_bag, size: 40),
                    ),
                  ),
                  title: Text(item['name']),
                  subtitle: Text(rupiah.format(item['price']),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await removeItem(item['id']);
                    },
                  ),
                ),
              );
            },
          ),
  );
}
}