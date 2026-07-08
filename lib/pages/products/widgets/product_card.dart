import 'package:flutter/material.dart';

import '../../../models/product_model.dart';
import '../../../theme/app.dart';

/// Widget kartu yang menampilkan informasi singkat sebuah produk.
/// Digunakan di daftar produk untuk menampilkan gambar, harga, stok, dan aksi tambah ke keranjang.
class ProductCard extends StatelessWidget {
  /// Data produk yang ditampilkan pada kartu.
  final ProductModel product;

  /// Fungsi untuk memformat harga produk ke format yang sesuai.
  final String Function(int) formatPrice;

  /// Callback saat kartu produk ditekan.
  final VoidCallback onTap;

  /// Callback saat tombol tambah ke keranjang ditekan.
  final VoidCallback onAddToCart;

  /// Menandakan apakah produk saat ini masuk daftar favorit pengguna.
  final bool isFavorite;

  /// Callback saat tombol favorit ditekan.
  final VoidCallback onFavoriteTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.formatPrice,
    required this.onTap,
    required this.onAddToCart,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.imageBackground(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// =======================
            /// IMAGE
            /// =======================

            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.imageBackground(context),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: product.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Icon(
                                    Icons.shopping_bag_rounded,
                                    size: 48,
                                    color: AppTheme.subtitleColor(context),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.shopping_bag_rounded,
                                size: 48,
                                color: AppTheme.subtitleColor(context),
                              ),
                            ),
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor(context),
                            shape: BoxShape.circle,
                            boxShadow: AppTheme.softShadow,
                          ),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.red
                                : AppTheme.iconColor(context),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// =======================
            /// INFO
            /// =======================

            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.label.copyWith(
                        fontSize: 14,
                        height: 1.2,
                        color: AppTheme.textColor(context),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      formatPrice(product.price),
                      style: AppTheme.price.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 14,
                          color: AppTheme.subtitleColor(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Stok ${product.stock}",
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.subtitleColor(context),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: ElevatedButton.icon(
                        onPressed: onAddToCart,
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 16,
                        ),
                        label: const Text("Keranjang"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}