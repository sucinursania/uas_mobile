import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/product_model.dart';
import '../../services/product_service.dart';
import '../../models/review_model.dart';
import '../../services/review_service.dart';
import '../../services/cart_service.dart';
import '../../theme/app.dart';

/// Halaman detail produk yang menampilkan informasi lengkap produk.
/// Menyediakan fitur melihat deskripsi, ulasan, dan menambahkan produk ke keranjang.
class ProductDetailPage extends StatefulWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  /// Layanan untuk mengambil data produk.
  final ProductService _productService = ProductService();

  /// Layanan untuk mengambil dan menambahkan ulasan produk.
  final ReviewService _reviewService = ReviewService();

  /// Layanan untuk menambahkan produk ke keranjang.
  final CartService _cartService = CartService();

  /// Controller untuk input ulasan pengguna.
  final TextEditingController _reviewController = TextEditingController();

  final NumberFormat rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  /// Data produk yang sedang ditampilkan.
  ProductModel? product;

  /// Daftar ulasan produk.
  List<ReviewModel> reviews = [];

  /// Rating yang dipilih pengguna untuk ulasan baru.
  int selectedRating = 5;

  /// Menandakan apakah data produk sedang dimuat.
  bool isLoading = true;

  /// Memuat detail produk dan ulasan saat halaman pertama kali dibuka.
  @override
  void initState() {
    super.initState();
    getProductDetail();
    getReviews();
  }

  /// Mengambil detail produk berdasarkan ID produk.
  Future<void> getProductDetail() async {
    try {
      final result = await _productService.getProductDetail(widget.productId);

      if (!mounted) return;

      setState(() {
        product = result;
      });
    } catch (e) {
      if (!mounted) return;

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

  /// Mengambil daftar ulasan untuk produk yang sedang ditampilkan.
  Future<void> getReviews() async {
    try {
      final result = await _reviewService.getReviews(widget.productId);
      debugPrint('Jumlah Review: ${result.length}');
      debugPrint(result.toString());

      if (!mounted) return;

      setState(() {
        reviews = result;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Menambahkan produk ke keranjang belanja pengguna.
  Future<void> addToCart() async {
    try {
      await _cartService.addToCart(productId: product!.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan ke keranjang'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  /// Mengirim ulasan baru untuk produk yang sedang ditampilkan.
  Future<void> submitReview() async {
    try {
      await _reviewService.addReview(
        productId: product!.id,
        rating: selectedRating,
        comment: _reviewController.text,
      );

      _reviewController.clear();

      setState(() {
        selectedRating = 5;
      });

      await getReviews();
      await getProductDetail();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ulasan berhasil ditambahkan')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  /// Memformat harga produk menjadi format rupiah.
  String formatPrice(int price) {
    return rupiah.format(price);
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Produk tidak ditemukan')),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            SizedBox(
              width: double.infinity,
              height: 320,
              child: Image.network(
                product!.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.imageBackground(context),
                    child: const Icon(
                      Icons.image_rounded,
                      size: 72,
                      color: AppTheme.textSecondary,
                    ),
                  );
                },
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor(context),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CATEGORY
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(
                          Theme.of(context).brightness == Brightness.dark
                              ? .20
                              : .10,
                        ),
                      ),
                      child: Text(
                        product!.category,
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // NAME
                    Text(
                      product!.name,
                      style: AppTheme.title.copyWith(
                        color: AppTheme.textColor(context),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // PRICE
                    Text(
                      formatPrice(product!.price),
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // RATING + STOCK
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppTheme.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${product!.averageRating}",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textColor(context),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "(${product!.totalReviews} ulasan)",
                          style: AppTheme.body,
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: AppTheme.subtitleColor(context),
                        ),
                        const SizedBox(width: 6),
                        Text("Stok ${product!.stock}", style: AppTheme.body),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text("Deskripsi", style: AppTheme.heading),

                    const SizedBox(height: 8),

                    Text(product!.description, style: AppTheme.body),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: addToCart,
                        icon: const Icon(Icons.shopping_cart_rounded),
                        label: const Text('Tambah ke Keranjang'),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text('Ulasan', style: AppTheme.heading),

                    const SizedBox(height: 12),

                    reviews.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Belum ada ulasan',
                              style: AppTheme.body,
                            ),
                          )
                        : Column(
                            children: reviews.map((review) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: SoftCard(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppTheme.primary.withOpacity(
                                                    .2,
                                                  )
                                                : AppTheme.primary.withOpacity(
                                                    .1,
                                                  ),
                                            backgroundImage:
                                                review.reviewerAvatar.isNotEmpty
                                                ? NetworkImage(
                                                    review.reviewerAvatar,
                                                  )
                                                : null,
                                            child: review.reviewerAvatar.isEmpty
                                                ? const Icon(
                                                    Icons.person_rounded,
                                                    color: AppTheme.primary,
                                                  )
                                                : null,
                                          ),

                                          const SizedBox(width: 10),

                                          Expanded(
                                            child: Text(
                                              review.reviewerName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.textColor(
                                                  context,
                                                ),
                                              ),
                                            ),
                                          ),

                                          Row(
                                            children: List.generate(
                                              review.rating,
                                              (_) => const Icon(
                                                Icons.star_rounded,
                                                color: AppTheme.warning,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        review.comment,
                                        style: AppTheme.body,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                    const SizedBox(height: 28),

                    Text('Tambah Ulasan', style: AppTheme.heading),

                    const SizedBox(height: 12),

                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                          icon: Icon(
                            Icons.star_rounded,
                            size: 28,
                            color: index < selectedRating
                                ? AppTheme.warning
                                : AppTheme.textSecondary.withOpacity(0.3),
                          ),
                        );
                      }),
                    ),

                    TextField(
                      controller: _reviewController,
                      maxLines: 3,
                      style: TextStyle(color: AppTheme.textColor(context)),
                      decoration: InputDecoration(
                        hintText: "Tulis ulasan...",
                        hintStyle: TextStyle(
                          color: AppTheme.subtitleColor(context),
                        ),
                        filled: true,
                        fillColor: AppTheme.cardColor(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: submitReview,
                        child: const Text('Kirim Ulasan'),
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
