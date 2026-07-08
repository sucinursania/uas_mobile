/// Model yang mewakili satu item dalam keranjang belanja.
/// Berisi informasi produk, jumlah pembelian, dan subtotal untuk item tersebut.
class CartItemModel {
  final String id;
  final int quantity;
  final int subtotal;

  final String productName;
  final String productImage;
  final int productPrice;

  CartItemModel({
    required this.id,
    required this.quantity,
    required this.subtotal,
    required this.productName,
    required this.productImage,
    required this.productPrice,
  });

  /// Membuat objek CartItemModel dari data JSON yang diterima dari API.
  factory CartItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CartItemModel(
      id: json['id'],
      quantity: json['quantity'],
      subtotal: json['subtotal'],

      productName:
          json['product']['name'],

      productImage:
          json['product']['image_url'],

      productPrice:
          json['product']['price'],
    );
  }
}