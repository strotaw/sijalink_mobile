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
      appBar: AppBar(title: Text(c.nama)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Header ---
          Container(
            decoration: AppStyles.card,
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
          Container(
            decoration: AppStyles.card,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Icon(
                      Icons.wifi_rounded,
                      color: Colors.white,
                      size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text('Paket Aktif',
                          style: AppStyles.caption),
                    ],
                  ),
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
          ),
          const SizedBox(height: 12),

          // --- Detail hardware / koneksi ---
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
    );
  }

  Widget _section(
      String title, IconData icon, List<Widget> rows) {
    return Container(
      decoration: AppStyles.card,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: AppStyles.h3),
            ],
          ),
          const SizedBox(height: 8),
          ...rows,
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value,
      {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: AppStyles.caption),
      subtitle: Text(value,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.textDark)),
      trailing: onTap == null
          ? null
          : IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.copy_rounded,
                  size: 18,
                  color: AppColors.textGrey),
            ),
    );
  }

  Widget _pppoePassRow() {
    final pass = widget.customer.pppoePass;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: const Icon(Icons.key_outlined,
          color: AppColors.primary),
      title:
          const Text('PPPoE Password',
              style: AppStyles.caption),
      subtitle: Text(
        _passVisible ? pass : '•' * pass.length,
        style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textDark),
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
                color: AppColors.textGrey),
          ),
          IconButton(
            onPressed: () => _copy(pass),
            icon: const Icon(Icons.copy_rounded,
                size: 18,
                color: AppColors.textGrey),
          ),
        ],
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
