import 'package:flutter/material.dart';

import '../../theme/app.dart';
import 'login_page.dart';
import 'register_page.dart';

/// Halaman pembuka aplikasi yang memperkenalkan fitur belanja.
/// Memberikan pilihan untuk masuk atau membuat akun baru.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Spacer(),

              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: AppTheme.shadow,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: AppTheme.primaryDark,
                    size: 52,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              Center(
                child: Text(
                  "Belanja Jadi Lebih Mudah",
                  style: AppTheme.title.copyWith(
                    color:  AppTheme.textColor(context), 
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 18),

              Center(
                child: Text(
                  "Temukan ribuan produk pilihan\ndengan pengalaman belanja yang nyaman.",
                  style: AppTheme.body.copyWith(
                    color: AppTheme.subtitleColor(context)
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                    );
                  },
                  child: Text("Login", style: AppTheme.button),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterPage(),
      ),
    );
  },
  style: OutlinedButton.styleFrom(
    side: BorderSide(
      color: Theme.of(context).dividerColor,
    ),
  ),
  child: Text(
    "Buat Akun",
    style: AppTheme.button.copyWith(
      color: Theme.of(context).colorScheme.primary,
    ),
  ),
),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}