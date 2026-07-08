import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../services/category_service.dart';
import '../../services/product_service.dart';
import '../../services/cart_service.dart';
import '../../theme/app.dart';
import '../cart/cart_page.dart';

import 'widgets/category_dropdown.dart';
import 'widgets/product_card.dart';
import 'widgets/product_search.dart';
import 'widgets/sort_dropdown.dart';
import 'product_detail_page.dart';
import '../../services/wishlist_service.dart';
import '../../services/notification_service.dart';

/// Halaman daftar produk yang menampilkan produk, filter, pencarian, dan aksi keranjang.
/// Pengguna dapat melihat produk, mencari, memilah berdasarkan kategori, dan menambahkan ke keranjang.
class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  /// Layanan untuk mengambil daftar produk.
  final ProductService _productService = ProductService();

  /// Layanan untuk mengambil daftar kategori produk.
  final CategoryService _categoryService = CategoryService();

  /// Layanan untuk mengelola keranjang belanja.
  final CartService _cartService = CartService();

  /// Controller untuk input pencarian produk.
  final TextEditingController _searchController = TextEditingController();

  final NumberFormat rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  /// Jumlah item yang ada pada keranjang pengguna.
  int cartCount = 0;

  /// Daftar produk yang ditampilkan saat ini.
  List<ProductModel> products = [];

  /// Daftar kategori yang tersedia untuk filter.
  List<CategoryModel> categories = [];

  /// Set ID produk yang masuk daftar favorit pengguna.
  Set<String> favoriteIds = {};

  /// Kata kunci pencarian aktif.
  String searchQuery = '';

  /// ID kategori yang dipilih untuk memfilter produk.
  String? selectedCategoryId;

  /// Opsi urutan produk yang dipilih pengguna.
  String? selectedSort;

  /// Menandakan apakah data produk sedang dimuat.
  bool isLoading = true;

  /// Memuat data favorit, kategori, produk, dan jumlah keranjang saat halaman pertama kali dibuka.
  @override
  void initState() {
    super.initState();
    favoriteIds = WishlistService.getAll() .map((item) => item['id'] as String).toSet();
    getCategories();
    getProducts();
    getCartCount();
    
  }

  /// Mengambil daftar produk sesuai filter, pencarian, dan urutan yang aktif.
  Future<void> getProducts() async {
    try {
      setState(() {
        isLoading = true;
      });

      final result = await _productService.getProducts(
        search: searchQuery,
        categoryId: selectedCategoryId,
        sort: selectedSort,
      );

      if (!mounted) return;

      setState(() {
        products = result;
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

  /// Mengambil daftar kategori yang tersedia.
  Future<void> getCategories() async {
    try {
      final result = await _categoryService.getCategories();

      if (!mounted) return;

      setState(() {
        categories = result;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Mengambil jumlah item keranjang pengguna untuk menampilkan badge.
  Future<void> getCartCount() async {
    try {
      final cart = await _cartService.getCart();

      if (!mounted) return;

      setState(() {
        cartCount = cart.totalItems;
      });
    } catch (_) {}
  }

  /// Menambahkan produk tertentu ke keranjang belanja pengguna.
  Future<void> addToCart(String productId) async {
    try {
      await _cartService.addToCart(productId: productId, quantity: 1);

      getCartCount();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan ke keranjang'),
        ),
      );
      await NotificationService.showNotification(
      title: "C! Mart",
      body: "Produk berhasil ditambahkan ke keranjang 🛒",
    );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  /// Mengubah status favorit suatu produk.
  Future<void> toggleFavorite(ProductModel product) async {
  if (favoriteIds.contains(product.id)) {
    await WishlistService.remove(product.id);

    setState(() {
      favoriteIds.remove(product.id);
    });
  } else {
    await WishlistService.add(
      id: product.id,
      name: product.name,
      price: product.price,
      imageUrl: product.imageUrl,
    );

    setState(() {
      favoriteIds.add(product.id);
    });
  }
}

  /// Memformat harga produk ke format rupiah.
  String formatPrice(int price) {
    return rupiah.format(price);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Produk'),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                  getCartCount();
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),

              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: AppTheme.danger,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartCount.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.backgroundColor(context),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ProductSearchBar(
                        controller: _searchController,
                        searchQuery: searchQuery,
                        onSearch: (value) {
                          setState(() {
                            searchQuery = value;
                          });

                          getProducts();
                        },
                        onClear: () {
                          _searchController.clear();

                          setState(() {
                            searchQuery = '';
                          });

                          getProducts();
                        },
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: CategoryDropdown(
                              categories: categories,
                              selectedCategoryId: selectedCategoryId,
                              onChanged: (value) {
                                setState(() {
                                  selectedCategoryId = value;
                                });

                                getProducts();
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: SortDropdown(
                              selectedSort: selectedSort,
                              onChanged: (value) {
                                setState(() {
                                  selectedSort = value;
                                });

                                getProducts();
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Expanded(
                        child: products.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 64,
                                      color: AppTheme.textSecondary
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Produk tidak ditemukan',
                                      style: AppTheme.body,
                                    ),
                                  ],
                                ),
                              )
                            : GridView.builder(
                                itemCount: products.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 14,
                                      mainAxisSpacing: 14,
                                      mainAxisExtent: 390,
                                    ),
                                itemBuilder: (context, index) {
                                  final product = products[index];

                                  return ProductCard(
                                    product: product,
                                    formatPrice: formatPrice,

                                    isFavorite: favoriteIds.contains(product.id), 
                                    onFavoriteTap: () {
                                      toggleFavorite(product);
                                    },

                                    onAddToCart: () {
                                      addToCart(product.id);
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailPage(
                                            productId: product.id,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
