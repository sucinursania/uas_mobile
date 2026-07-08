import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/order_model.dart';
import '../../services/order_service.dart';
import '../../theme/app.dart';

/// Halaman detail pesanan yang menampilkan informasi lengkap satu pesanan.
/// Memuat status, alamat pengiriman, catatan, tanggal, dan total pembayaran.
class OrderDetailPage extends StatefulWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  /// Layanan untuk mengambil detail pesanan dari API.
  final OrderService _orderService = OrderService();

  /// Data pesanan yang sedang ditampilkan.
  OrderModel? order;
  final rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  /// Menandakan apakah data pesanan sedang dimuat.
  bool isLoading = true;

  /// Memuat detail pesanan saat halaman pertama kali dibuka.
  @override
  void initState() {
    super.initState();
    getDetail();
  }

  /// Mengambil detail pesanan berdasarkan ID yang diterima dari widget.
  Future<void> getDetail() async {
    try {
      final result = await _orderService.getOrderDetail(widget.orderId);

      if (!mounted) return;
      setState(() {
        order = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// Membuat blok informasi berisi label dan nilai untuk ditampilkan di halaman.
  Widget _infoBlock(BuildContext context, String label, String value) {
    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTheme.label.copyWith(color: AppTheme.textColor(context)),
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTheme.body),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : order == null
          ? const Center(child: Text('Pesanan tidak ditemukan'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.statusColor(
                        order!.status,
                      ).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order!.status.toUpperCase(),
                      style: TextStyle(
                        color: AppTheme.statusColor(order!.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _infoBlock(context, 'Alamat Pengiriman', order!.shippingAddress),
                  const SizedBox(height: 12),
                  _infoBlock(context, 'Catatan', order!.notes ?? '-'),
                  const SizedBox(height: 12),
                  _infoBlock(context, 'Tanggal Pesanan',
                    DateFormat('dd MMM yyyy HH:mm').format(order!.createdAt),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor(context),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.shadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTheme.heading),

                        Text(
                          rupiah.format(order!.totalAmount),
                          style: AppTheme.price.copyWith(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
