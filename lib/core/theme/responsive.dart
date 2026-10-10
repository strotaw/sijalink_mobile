import 'package:flutter/widgets.dart';

/// Skala responsif berbasis lebar desain 360px.
///
/// Flutter memakai logical pixel (density-independent), jadi ukuran
/// tetap seperti `fontSize: 14` sejatinya sudah konsisten di semua HP.
/// Yang perlu skala adalah matematika layout kustom (lebar item
/// carousel, lingkaran nav, avatar) agar proporsinya sama di layar
/// kecil (320px) maupun besar (430px+).
///
/// Pakai: `context.rs(64)` untuk 64px desain.
extension ResponsiveX on BuildContext {
  double get _lebarLayar =>
      MediaQuery.sizeOf(this).width;

  /// Faktor skala lebar, dijepit 0.85–1.2 agar tidak ekstrem.
  double get skala =>
      (_lebarLayar / 360).clamp(0.85, 1.2);

  /// Skalakan [pxDesain] (acuan layar 360px) ke layar aktual.
  double rs(double pxDesain) => pxDesain * skala;

  /// True di HP kecil (lebar < 360).
  bool get layarKecil => _lebarLayar < 360;
}
