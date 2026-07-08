import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kumpulan tema, warna, teks, dan helper UI yang digunakan di seluruh aplikasi.
class AppTheme {
  // ===========================
  // COLORS
  // ===========================

  static const Color primary = Color(0xFF22C55E);
  static const Color primaryDark = Color(0xFF16A34A);

  static const Color background = Color(0xFFF8FAFC);



  static const Color textPrimary = Color(0xFF111827);

  static const Color textSecondary = Color(0xFF6B7280);

  static const Color border = Color(0xFFE5E7EB);

  static const Color danger = Color(0xFFEF4444);

  static const Color warning = Color(0xFFF59E0B);

  /// Style teks untuk label UI.
  static TextStyle get label => GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

static TextStyle get caption => GoogleFonts.poppins(
      fontSize: 13,
    );

  // ===========================
  // BORDER
  // ===========================

  static const double radius = 20;

  // ===========================
  // SHADOW
  // ===========================

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(.03),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> shadow = [
    BoxShadow(
      color: Colors.black.withOpacity(.05),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  // ===========================
  // TEXT STYLE
  // ===========================

  static TextStyle get title => GoogleFonts.poppins(
        fontSize: 30,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get heading => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 15,
        height: 1.6,
      );

  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get price => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  // ===========================
  // THEME
  // ===========================

  /// Tema terang aplikasi.
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    fontFamily: GoogleFonts.poppins().fontFamily,
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: background,
    cardColor:  Colors.white,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: textPrimary,
      centerTitle: false,
    ),

    dividerColor: border,

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        side: const BorderSide(color: border),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: primary,
          width: 1.5,
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
  backgroundColor: Colors.white,
  indicatorColor: primary.withOpacity(.12),
  labelTextStyle: WidgetStateProperty.resolveWith(
    (states) => GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: states.contains(WidgetState.selected)
          ? primaryDark
          : Colors.grey.shade700,
    ),
  ),
  iconTheme: WidgetStateProperty.resolveWith(
    (states) => IconThemeData(
      color: states.contains(WidgetState.selected)
          ? primaryDark
          : Colors.grey.shade600,
    ),
  ),
),
  );

  // ===========================
  // DARK THEME
  // ===========================

  /// Tema gelap aplikasi.
  static ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.poppins().fontFamily,

  brightness: Brightness.dark,

  scaffoldBackgroundColor: const Color(0xFF0F172A),
  cardColor: const Color(0xFF1E293B),
  textTheme: GoogleFonts.poppinsTextTheme(
  ThemeData.dark().textTheme,
).apply(
  bodyColor: Colors.white,
  displayColor: Colors.white,
),
iconTheme: const IconThemeData(
  color: Colors.white,
),

  colorScheme: const ColorScheme.dark(
    primary: primary,
    secondary: primaryDark,
    surface: Color(0xFF1E293B),
    onSurface: Colors.white,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),

  cardTheme: CardThemeData(
    color: const Color(0xFF1E293B),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E293B),

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 18,
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(
        color: primary,
        width: 1.5,
      ),
    ),

    hintStyle: const TextStyle(
      color: Colors.white60,
    ),

    labelStyle: const TextStyle(
      color: Colors.white70,
    ),
  ),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: const Color(0xFF1E293B),
    indicatorColor: primary.withOpacity(.2),
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) => GoogleFonts.poppins(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
    ),
    iconTheme: WidgetStateProperty.all(
      const IconThemeData(color: Colors.white),
    ),
  ),

  dividerColor: Colors.white12,
);
// ===========================
// DYNAMIC COLORS
// ===========================

  /// Mengambil warna latar belakang sesuai tema aktif.
  static Color backgroundColor(BuildContext context) {
  return Theme.of(context).scaffoldBackgroundColor;
}

  /// Mengambil warna card sesuai tema aktif.
  static Color cardColor(BuildContext context) {
  return Theme.of(context).cardColor;
}

  /// Mengambil warna teks utama sesuai tema aktif.
  static Color textColor(BuildContext context) {
  return Theme.of(context).colorScheme.onSurface;
}

  /// Mengambil warna teks sekunder sesuai tema aktif.
  static Color subtitleColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white70
      : textSecondary;
}

  /// Mengambil warna background untuk area gambar sesuai tema aktif.
  static Color imageBackground(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF334155)
      : const Color(0xFFF8FAFC);
}

  /// Mengambil warna ikon sesuai tema aktif.
  static Color iconColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : textPrimary;
}

  /// Mengecek apakah tema saat ini adalah mode gelap.
  static bool isDark(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}
  // ===========================
  // STATUS
  // ===========================

  /// Mengambil warna status pesanan berdasarkan statusnya.
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return warning;

      case 'processing':
        return Colors.blue;

      case 'shipped':
        return Colors.deepPurple;

      case 'delivered':
        return primaryDark;

      case 'cancelled':
        return danger;

      default:
        return Colors.grey;
    }
  }
}

/// Widget card dengan desain lembut dan bayangan ringan.
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppTheme.cardColor(context),
            borderRadius: BorderRadius.circular(AppTheme.radius),
            boxShadow: AppTheme.softShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}