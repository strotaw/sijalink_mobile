import 'package:flutter/material.dart';
import 'app_colors.dart';

/// "CSS template" Flutter: ThemeData global + TextStyles reusable.
abstract class AppTheme {
  static ThemeData light() {
    const seed = AppColors.primary;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      primary: seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: seed,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: const StadiumBorder(),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(
              color: AppColors.primary, width: 1.5),
          shape: const StadiumBorder(),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary,
        labelTextStyle: WidgetStatePropertyAll(
          const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.sidebarBg,
        selectedIconTheme: IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: AppColors.sidebarInactive),
      ),
    );
  }
}

abstract class AppStyles {
  // Headings (seperti h1-h4 di CSS)
  static const h1 = TextStyle(
      fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textDark);
  static const h2 = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark);
  static const h3 = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark);
  static const body = TextStyle(fontSize: 14, color: AppColors.textGrey);
  static const caption = TextStyle(fontSize: 12, color: AppColors.textGrey);

  // Utilities ala CSS class — extra round + solid
  static BoxDecoration card = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF0C70A4).withValues(alpha: 0.08),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static BoxDecoration pill(Color bg) => BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      );

  static const EdgeInsets pagePadding = EdgeInsets.all(24);
}
