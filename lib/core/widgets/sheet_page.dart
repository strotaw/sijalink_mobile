import 'package:flutter/material.dart';

/// Buka halaman sebagai popup dari bawah (70% tinggi layar),
/// bukan full-screen.
Future<void> bukaHalamanSheet(
    BuildContext context, Widget page) {
  final tinggi = MediaQuery.of(context).size.height * 0.7;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SizedBox(
      height: tinggi,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius:
                  BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              child: page,
            ),
          ),
        ],
      ),
    ),
  );
}
