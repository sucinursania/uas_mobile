import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import '../../theme/app.dart';
import '../auth/welcome_page.dart';
import '../products/product_page.dart';
import '../../widgets/common/promo_banner.dart';
import '../../widgets/common/section_title.dart';
import '../../services/cart_service.dart';
import '../cart/cart_page.dart';

/// Halaman beranda utama aplikasi yang menampilkan sambutan dan navigasi ke produk.
/// Digunakan sebagai konten utama pada layar home pengguna.
class HomeContentPage extends StatefulWidget {
  const HomeContentPage({super.key});

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  final CartService _cartService = CartService();

  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    getCartCount();
  }

  /// Menghapus token autentikasi pengguna dan mengarahkan kembali ke halaman welcome.
  Future<void> logout(BuildContext context) async {
    await StorageService.removeToken();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (route) => false,
    );
  }

  Future<void> getCartCount() async {
    try {
      final cart = await _cartService.getCart();

      if (!mounted) return;

      setState(() {
        cartCount = cart.totalItems;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "C! Mart",
          style: AppTheme.heading.copyWith(color: AppTheme.textColor(context)),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );

                  getCartCount();
                },
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
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Halo 👋",
                style: AppTheme.body.copyWith(
                  color: AppTheme.subtitleColor(context),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Selamat Datang di C! Mart",
                style: AppTheme.title.copyWith(
                  color: AppTheme.textColor(context),
                ),
              ),

              const SizedBox(height: 24),

              const PromoBanner(),

              const SizedBox(height: 30),

              SectionTitle(
                title: "Belanja",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductPage()),
                  );
                },
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProductPage()),
                    );
                  },
                  icon: const Icon(Icons.storefront),
                  label: const Text("Lihat Semua Produk"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
