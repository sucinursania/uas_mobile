import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_mobile/models/cart_model.dart';

import '../../services/order_service.dart';
import '../../services/notification_service.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../theme/app.dart';

/// Halaman checkout yang digunakan untuk meninjau pesanan sebelum dibuat.
/// Memungkinkan pengguna mengisi alamat pengiriman, menambahkan catatan, dan membuat pesanan.
class CheckoutPage extends StatefulWidget {
  final CartModel cart;

  const CheckoutPage({
    super.key,
    required this.cart,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  /// Controller untuk input alamat pengiriman.
  final TextEditingController addressController = TextEditingController();

  /// Controller untuk input catatan tambahan pesanan.
  final TextEditingController noteController = TextEditingController();

  /// Layanan untuk membuat pesanan baru.
  final OrderService _orderService = OrderService();
  final rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  /// Menandakan apakah proses pembuatan pesanan sedang berlangsung.
  bool isLoading = false;

  /// Membuat pesanan berdasarkan data yang dimasukkan pengguna.
  Future<void> createOrder() async {
    if (addressController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat minimal 10 karakter')),
      );
      return;
    }

    final confirm = await showConfirmDialog(
      context: context,
      title: "Konfirmasi Checkout",
      message: "Yakin ingin membuat pesanan?",
    );

    if (confirm != true) return;
    try {
      setState(() {
        isLoading = true;
      });

      await _orderService.createOrder(
        shippingAddress: addressController.text,
        notes: noteController.text,
      );

      await NotificationService.showNotification(
        title: 'Checkout Berhasil',
        body: 'Pesanan kamu sedang diproses.',
      );

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Pesanan berhasil dibuat'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              child: const Text('Lihat Pesanan'),
            ),
          ],
        ),
      );
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
  void dispose() {
    addressController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text('Ringkasan Pesanan', style: AppTheme.heading),

                  const SizedBox(height: 12),

                  SoftCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Column(
                      children: [
                        ...widget.cart.items.map(
                          (item) => ListTile(
                            title: Text(
                              item.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '${item.quantity} x ${rupiah.format(item.productPrice)}',
                              style: AppTheme.body,
                            ),
                            trailing: Text(
                              rupiah.format(item.subtotal),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textColor(context),
                              ),
                            ),
                          ),
                        ),

                        const Divider(height: 1),

                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Grand Total',
                                style: AppTheme.label.copyWith(
                                color: AppTheme.textColor(context)
                                ),
                              ),
                              Text(
                                rupiah.format(widget.cart.grandTotal),
                                style: AppTheme.label.copyWith(
                                color: AppTheme.textColor(context),
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: addressController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Pengiriman',
                      alignLabelWithHint: true,
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Catatan (opsional)',
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: isLoading ? null : createOrder,
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.4,
                        ),
                      )
                    : const Text('Buat Pesanan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
