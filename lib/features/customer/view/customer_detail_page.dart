import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/customer_cubit.dart';

class CustomerDetailPage extends StatefulWidget {
  final Customer customer;
  const CustomerDetailPage({super.key, required this.customer});

  @override
  State<CustomerDetailPage> createState() =>
      _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  bool _passVisible = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.customer;
    final aktif = c.status == 'Aktif';
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text(c.nama),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(
              vertical: 16),
          children: [
            // --- Bubble identitas (terpisah) ---
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary,
                  child: Text(c.nama[0],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(c.nama,
                          style: AppStyles.h2),
                      Text('${c.id} • Sejak ${c.tglPemasangan}',
                          style: AppStyles.caption),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: aktif
                        ? AppColors.successBg
                        : AppColors.dangerBg,
                    borderRadius:
                        BorderRadius.circular(100),
                  ),
                  child: Text(c.status,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: aktif
                              ? AppColors.success
                              : AppColors.danger)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // --- Data pelanggan ---
          _section('Data Pelanggan', Icons.person_rounded, [
            _row(Icons.badge_outlined, 'Nama Lengkap',
                c.nama),
            _row(Icons.location_on_outlined, 'Alamat',
                c.alamat),
            _row(Icons.phone_outlined, 'No. Telp',
                c.telp, onTap: () => _copy(c.telp)),
            _row(
                Icons.calendar_month_outlined,
                'Tanggal Pemasangan',
                c.tglPemasangan),
          ]),
          const SizedBox(height: 12),

          // --- Paket ---
          _section('Paket', Icons.wifi_rounded, [
            Row(
              children: [
                const Expanded(
                  child: Text('Paket Aktif',
                      style: AppStyles.caption),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.infoBg,
                    borderRadius:
                        BorderRadius.circular(100),
                  ),
                  child: Text(c.paket,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 12),

          // --- Detail hardware / koneksi (terpisah) ---
          _section(
              'Detail Hardware & Koneksi',
              Icons.router_rounded, [
            _row(Icons.account_circle_outlined,
                'PPPoE Username', c.pppoeUser,
                onTap: () => _copy(c.pppoeUser)),
            _pppoePassRow(),
            _row(Icons.hub_outlined,
                'ODP Terhubung', c.odp),
            _row(Icons.dns_outlined,
                'Mikrotik', c.mikrotik),
          ]),
        ],
        ),
      ),
    );
  }

  /// Bubble putih full-bleed (atas 30, bawah 50);
  /// judul section teks besar tanpa background.
  Widget _section(
      String title, IconData icon, List<Widget> rows) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon,
                  color: AppColors.primary,
                  size: 26),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 20),
          ...rows,
        ],
      ),
    );
  }

  /// Kotak teks biru: label putih redup + nilai putih.
  Widget _row(IconData icon, String label, String value,
      {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 4),
        dense: true,
        leading:
            Icon(icon, color: Colors.white),
        title: Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.white70)),
        subtitle: Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.white)),
        trailing: onTap == null
            ? null
            : IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.copy_rounded,
                    size: 18, color: Colors.white),
              ),
      ),
    );
  }

  Widget _pppoePassRow() {
    final pass = widget.customer.pppoePass;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 4),
        dense: true,
        leading: const Icon(Icons.key_outlined,
            color: Colors.white),
        title: const Text('PPPoE Password',
            style: TextStyle(
                fontSize: 12,
                color: Colors.white70)),
        subtitle: Text(
          _passVisible ? pass : '•' * pass.length,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.white),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => setState(
                  () => _passVisible = !_passVisible),
              icon: Icon(
                  _passVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: Colors.white),
            ),
            IconButton(
              onPressed: () => _copy(pass),
              icon: const Icon(Icons.copy_rounded,
                  size: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Disalin ke clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: StadiumBorder(),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
