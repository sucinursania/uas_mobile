import 'cart_item_model.dart';

/// Model yang mewakili isi keranjang belanja secara keseluruhan.
/// Menyimpan daftar item, jumlah total barang, dan total pembayaran akhir.
class CartModel {
  final String cartId;
  final List<CartItemModel> items;
  final int totalItems;
  final int grandTotal;

  CartModel({
    required this.cartId,
    required this.items,
    required this.totalItems,
    required this.grandTotal,
  });

  /// Membuat objek CartModel dari data JSON keranjang belanja.
  factory CartModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CartModel(
      cartId: json['cart_id'],
      items: (json['items'] as List)
          .map(
            (e) => CartItemModel.fromJson(e),
          )
          .toList(),
      totalItems: json['total_items'],
      grandTotal: json['grand_total'],
    );
  }
}