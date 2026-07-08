import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/cart_item_model.dart';
import '../../../theme/app.dart';

/// Widget yang menampilkan satu item produk dalam keranjang belanja.
/// Menyediakan informasi produk, harga, kuantitas, dan aksi tambah/kurangi/hapus.
class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onPlus;
  final VoidCallback onMinus;
  final VoidCallback onDelete;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onPlus,
    required this.onMinus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final rupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SoftCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                item.productImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: AppTheme.imageBackground(context),
                    child: const Icon(
                      Icons.image_rounded,
                      color: AppTheme.textSecondary,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppTheme.textColor(context),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
  rupiah.format(item.productPrice),
  style: AppTheme.body.copyWith(
    color: AppTheme.subtitleColor(context),
  ),
),

                  const SizedBox(height: 6),

                  Text(
                    'Subtotal: ${rupiah.format(item.subtotal)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textColor(context),
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QtyButton(icon: Icons.remove_rounded, onTap: onMinus),

                      SizedBox(
                        width: 32,
                        child: Text(
                          item.quantity.toString(),
                          textAlign: TextAlign.center,
                          style: AppTheme.label.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textColor(context),
                          ),
                        ),
                      ),

                      _QtyButton(icon: Icons.add_rounded, onTap: onPlus),

                      const Spacer(),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppTheme.danger,
                        ),
                      ),
                    ],
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

/// Tombol kecil untuk menambah atau mengurangi jumlah item pada keranjang.
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
    ? AppTheme.primary.withOpacity(.18)
    : AppTheme.primary.withOpacity(.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppTheme.primary),
      ),
    );
  }
}
