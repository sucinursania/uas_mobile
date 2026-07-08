import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import '../../theme/app.dart';
import '../auth/welcome_page.dart';
import '../home/main_page.dart';

/// Halaman splash screen yang muncul saat aplikasi dimulai.
/// Memeriksa status login pengguna dan mengarahkan ke halaman yang sesuai.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// Memeriksa status login saat halaman splash pertama kali dibuka.
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  /// Memeriksa token penyimpanan untuk menentukan apakah pengguna sudah login.
  Future<void> checkLogin() async {
    final token = await StorageService.getToken();

    if (!mounted) return;

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 42,
              ),
            ),

            const SizedBox(height: 28),

            const CircularProgressIndicator(
              color: AppTheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}