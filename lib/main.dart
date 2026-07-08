import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/splash/splash_page.dart';
import 'providers/theme_provider.dart';
import 'theme/app.dart';
import 'services/notification_service.dart';

/// Titik masuk utama aplikasi Flutter.
/// Menginisialisasi layanan lokal, tema, dan menjalankan aplikasi.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Membuka box wishlist
  await Hive.openBox('wishlist');

  // Load tema
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();
  await NotificationService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: const MyApp(),
    ),
  );
}

/// Widget akar aplikasi yang mengatur tema dan halaman awal.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const SplashPage(),
    );
  }
}