/// Model yang mewakili satu pesanan dalam sistem.
/// Menyimpan status, alamat pengiriman, catatan, total pembayaran, dan tanggal dibuat.
class OrderModel {
  final String id;
  final String status;
  final String shippingAddress;
  final String? notes;
  final int totalAmount;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.status,
    required this.shippingAddress,
    this.notes,
    required this.totalAmount,
    required this.createdAt,
  });

  /// Membuat objek OrderModel dari data JSON yang diterima dari API.
  factory OrderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderModel(
      id: json['id'],
      status: json['status'],
      shippingAddress:
          json['shipping_address'],
      notes: json['notes'],
      totalAmount:
          json['grand_total'] ??
          json['total_amount'],
      createdAt:
          DateTime.parse(
            json['created_at'],
          ),
    );
  }
}