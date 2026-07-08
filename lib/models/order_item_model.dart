/// Model yang mewakili satu item dalam sebuah pesanan.
/// Menyimpan informasi produk, jumlah pembelian, harga satuan, dan subtotal.
class OrderItemModel {
  final String productName;
  final int quantity;
  final int price;
  final int subtotal;

  OrderItemModel({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  /// Membuat objek OrderItemModel dari data JSON yang diterima dari API.
  factory OrderItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderItemModel(
      productName:
          json['product']['name'],
      quantity:
          json['quantity'],
      price:
          json['price'],
      subtotal:
          json['subtotal'],
    );
  }
}