import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/cart_model.dart';
import '../../services/cart_service.dart';
import '../../theme/app.dart';
import '../../widgets/common/confirm_dialog.dart';
import 'cart_item_card.dart';
import '../orders/checkout_page.dart';

/// Halaman keranjang belanja yang menampilkan item yang dipilih pengguna.
/// Memungkinkan pengguna melihat subtotal, mengubah jumlah, menghapus item, dan melanjutkan checkout.
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  /// Layanan untuk mengambil dan mengubah data keranjang.
  final CartService _cartService = CartService();
  final NumberFormat rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  CartModel? _cart;
  bool _isLoading = true;

  /// Memuat data keranjang saat halaman pertama kali dibuka.
  @override
  void initState() {
    super.initState();
    getCart();
  }

  /// Mengambil data keranjang terbaru dari layanan.
  Future<void> getCart() async {
    try {
      final result = await _cartService.getCart();
      if (!mounted) return;
      setState(() {
        _cart = result;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Mengubah jumlah item pada keranjang berdasarkan ID item.
  Future<void> updateQuantity(String id, int quantity) async {
    try {
      await _cartService.updateCart(id, quantity);

      getCart();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  /// Menghapus satu item dari keranjang.
  Future<void> deleteItem(String id) async {
    try {
      await _cartService.deleteItem(id);

      getCart();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  /// Menghapus semua item dari keranjang setelah konfirmasi pengguna.
  Future<void> clearCart() async {
    final confirm = await showConfirmDialog(
      context: context,
      title: "Kosongkan Keranjang",
      message: "Yakin ingin menghapus semua item?",
      confirmText: "Hapus",
    );

    if (confirm != true) return;
    try {
      await _cartService.clearCart();
      getCart();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang berhasil dikosongkan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      appBar: AppBar(
        title: const Text('Keranjang'),
        actions: [
          IconButton(
            onPressed: clearCart,
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cart == null || _cart!.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 90,
                    color: AppTheme.subtitleColor(context).withOpacity(.45),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Keranjang masih kosong',
                    style: AppTheme.body.copyWith(
                      color: AppTheme.subtitleColor(context),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: _cart!.items.length,
                    itemBuilder: (context, index) {
                      final item = _cart!.items[index];

                      return CartItemCard(
                        item: item,
                        onPlus: () {
                          updateQuantity(item.id, item.quantity + 1);
                        },

                        onMinus: () {
                          if (item.quantity > 1) {
                            updateQuantity(item.id, item.quantity - 1);
                          }
                        },

                        onDelete: () {
                          deleteItem(item.id);
                        },
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor(context),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    border: Border(
                      top: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                    boxShadow: AppTheme.shadow,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Grand Total', style: AppTheme.heading),

                          Text(
                            rupiah.format(_cart!.grandTotal),
                            style: AppTheme.price.copyWith(fontSize: 22),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutPage(
                                  cart: _cart!,
                                ),
                              ),
                            );

                            if (result == true) {
                              getCart();
                            }
                          },
                          child: const Text('Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
