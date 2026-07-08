import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/order_model.dart';
import '../../services/order_service.dart';
import '../../theme/app.dart';
import 'order_detail_page.dart';

/// Halaman riwayat pesanan yang menampilkan daftar semua pesanan pengguna.
/// Memungkinkan pengguna melihat detail setiap pesanan yang pernah dibuat.
class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  /// Layanan untuk mengambil daftar pesanan pengguna.
  final OrderService _orderService = OrderService();

  /// Daftar pesanan yang sedang ditampilkan.
  List<OrderModel> orders = [];

  /// Menandakan apakah data pesanan sedang dimuat.
  bool isLoading = true;

  /// Memuat daftar pesanan saat halaman pertama kali dibuka.
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  /// Mengambil daftar pesanan dari layanan.
  Future<void> getOrders() async {
    try {
      final result = await _orderService.getOrders();
      if (!mounted) return;
      setState(() {
        orders = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final rupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      appBar: AppBar(title: const Text('Riwayat Pesanan')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 90,
                    color: AppTheme.textSecondary.withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  Text('Belum ada pesanan', style: AppTheme.body),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: SoftCard(
                    padding: const EdgeInsets.all(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailPage(orderId: order.id),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #${order.id.substring(0, 8)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textColor(context),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                dateFormat.format(order.createdAt),
                                style: AppTheme.body,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                rupiah.format(order.totalAmount),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.statusColor(order.status)
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.status.toUpperCase(),
                            style: TextStyle(
                              color: AppTheme.statusColor(order.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppTheme.subtitleColor(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
