import 'package:flutter/material.dart';

/// CSS-template equivalent: semua warna terpusat di sini.
/// Primary brand: #0C70A4 — solid, tanpa transparansi di UI.
abstract class AppColors {
  static const Color primary = Color(0xFF0C70A4);
  static const Color primaryDark = Color(0xFF084E75);
  static const Color primaryLight = Color(0xFFD6E9F5);
  static const Color primarySoft = Color(0xFF1488C2);

  static const Color background = Color(0xFFEEF3F7);
  static const Color surface = Colors.white;
  static const Color sidebarBg = Color(0xFF0C70A4);
  static const Color sidebarActive = Colors.white;
  static const Color sidebarInactive = Color(0xFFC9E2F0);

  static const Color textDark = Color(0xFF16283A);
  static const Color textGrey = Color(0xFF5D7285);
  static const Color border = Color(0xFFDCE5ED);

  // Warna status solid (opaque, bukan alpha tipis)
  static const Color success = Color(0xFF15803D);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFB45309);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFB91C1C);
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0C70A4);
  static const Color infoBg = Color(0xFFD6E9F5);
}
