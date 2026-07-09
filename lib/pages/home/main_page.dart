import 'package:flutter/material.dart';

import '../cart/cart_page.dart';
import '../products/product_page.dart';
import '../profile/profile_page.dart';
import '../products/wishlist_page.dart';
import '../orders/order_history_page.dart';
import '../../theme/app.dart';
import 'home_page.dart';

/// Halaman utama aplikasi yang mengelola navigasi antar menu utama.
/// Menyediakan bottom navigation bar untuk beralih ke halaman home, produk, keranjang, wishlist, dan profil.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// Indeks tab yang sedang aktif pada bottom navigation bar.
  int currentIndex = 0;

  /// Daftar halaman yang dapat diakses melalui navigasi utama.
  final List<Widget> pages = [
    const HomeContentPage(),
    const ProductPage(),
    const OrderHistoryPage(),
    const WishlistPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
  decoration: BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(24),
    boxShadow: AppTheme.softShadow,
  ),
  child: NavigationBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    height: 72,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    indicatorColor: AppTheme.primary.withOpacity(.18),

    selectedIndex: currentIndex,

    onDestinationSelected: (index) {
      setState(() {
        currentIndex = index;
      });
    },

    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: "Home",
      ),
      NavigationDestination(
        icon: Icon(Icons.storefront_outlined),
        selectedIcon: Icon(Icons.storefront),
        label: "Produk",
      ),
      NavigationDestination(
        icon: Icon(Icons.shopping_bag_outlined),
        selectedIcon: Icon(Icons.shopping_bag),
        label: "Riwayat",
      ),
      NavigationDestination(
        icon: Icon(Icons.favorite_border),
        selectedIcon: Icon(Icons.favorite),
        label: "Wishlist",
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: "Profil",
      ),
    ],
  ),
),
      
    );
  }
}