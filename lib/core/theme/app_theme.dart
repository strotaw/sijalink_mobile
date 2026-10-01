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
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
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

  // Utilities ala CSS class
  static BoxDecoration card = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static const EdgeInsets pagePadding = EdgeInsets.all(24);
}
