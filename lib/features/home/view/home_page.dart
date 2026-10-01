import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../attendance/bloc/attendance_cubit.dart';
import '../../mikrotik/bloc/mikrotik_cubit.dart';
import '../../spk/bloc/spk_cubit.dart';
import 'attendance_page.dart';
import 'mikrotik_page.dart';
import 'spk_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _greetingCard(context),
          const SizedBox(height: 16),
          _kehadiranCard(context),
          const SizedBox(height: 16),
          const Text('Menu Teknisi', style: AppStyles.h3),
          const SizedBox(height: 10),
          _menuGrid(context),
          const SizedBox(height: 16),
          _spkAktif(context),
          const SizedBox(height: 16),
          _mikrotikCard(context),
        ],
      ),
    );
  }

  Widget _greetingCard(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo, Teknisi 👋',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: 4),
            Text('Siap bertugas hari ini? 3 SPK menunggu.',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
      );

  Widget _kehadiranCard(BuildContext context) =>
      BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, s) => Container(
          decoration: AppStyles.card,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.fingerprint,
                      color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Kehadiran Hari Ini',
                      style: AppStyles.h3),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: _jamBox('Masuk', s.jamMasuk ?? '--:--')),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _jamBox('Keluar', s.jamKeluar ?? '--:--')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12))),
                      onPressed: s.sudahCheckIn
                          ? null
                          : () => context
                              .read<AttendanceCubit>()
                              .checkIn(),
                      icon: const Icon(Icons.login, size: 18),
                      label: Text(s.sudahCheckIn
                          ? 'Sudah Check-In'
                          : 'Check-In'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                              color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12))),
                      onPressed: (!s.sudahCheckIn ||
                              s.sudahCheckOut)
                          ? null
                          : () => context
                              .read<AttendanceCubit>()
                              .checkOut(),
                      icon: const Icon(Icons.logout, size: 18),
                      label: Text(s.sudahCheckOut
                          ? 'Sudah Pulang'
                          : 'Check-Out'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _jamBox(String label, String jam) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label, style: AppStyles.caption),
            Text(jam,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ],
        ),
      );

  Widget _menuGrid(BuildContext context) {
    final menus = [
      (Icons.fingerprint, 'Kehadiran', const AttendancePage()),
      (Icons.assessment_rounded, 'Laporan\nKehadiran', const AttendancePage(showReport: true)),
      (Icons.assignment_rounded, 'SPK', const SpkPage()),
      (Icons.router_rounded, 'Mikrotik', const MikrotikPage()),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 96),
      itemCount: menus.length,
      itemBuilder: (_, i) {
        final (icon, label, page) = menus[i];
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => page)),
          child: Container(
            decoration: AppStyles.card,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(height: 6),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _spkAktif(BuildContext context) =>
      BlocBuilder<SpkCubit, SpkState>(
        builder: (context, s) {
          final aktif =
              s.list.where((e) => e.status != SpkStatus.selesai).toList();
          return Container(
            decoration: AppStyles.card,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('SPK Aktif', style: AppStyles.h3),
                    const Spacer(),
                    TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SpkPage())),
                        child: const Text('Lihat Semua')),
                  ],
                ),
                for (final spk in aktif.take(3))
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius:
                              BorderRadius.circular(10)),
                      child: const Icon(Icons.assignment,
                          color: AppColors.primary, size: 20),
                    ),
                    title: Text('${spk.no} • ${spk.jenis}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    subtitle: Text(spk.customer,
                        style: AppStyles.caption),
                    trailing: _spkBadge(spk.status),
                  ),
              ],
            ),
          );
        },
      );

  Widget _spkBadge(SpkStatus s) {
    final (txt, c) = switch (s) {
      SpkStatus.baru => ('Baru', AppColors.info),
      SpkStatus.proses => ('Proses', AppColors.warning),
      SpkStatus.selesai => ('Selesai', AppColors.success),
    };
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: c.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20)),
      child: Text(txt,
          style: TextStyle(color: c, fontSize: 11)),
    );
  }

  Widget _mikrotikCard(BuildContext context) =>
      BlocBuilder<MikrotikCubit, MikrotikState>(
        builder: (context, s) => Container(
          decoration: AppStyles.card,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Mikrotik di Manage',
                      style: AppStyles.h3),
                  const Spacer(),
                  TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const MikrotikPage())),
                      child: const Text('Detail')),
                ],
              ),
              for (final m in s.list)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.router,
                      color: m.online
                          ? AppColors.success
                          : AppColors.danger),
                  title: Text(m.nama,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  subtitle: Text('${m.ip} • ${m.clientCount} klien',
                      style: AppStyles.caption),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: (m.online
                                ? AppColors.success
                                : AppColors.danger)
                            .withValues(alpha: 0.12),
                        borderRadius:
                            BorderRadius.circular(20)),
                    child: Text(m.online ? 'Online' : 'Offline',
                        style: TextStyle(
                            fontSize: 11,
                            color: m.online
                                ? AppColors.success
                                : AppColors.danger)),
                  ),
                ),
            ],
          ),
        ),
      );
}
