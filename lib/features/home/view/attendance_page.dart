import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../attendance/bloc/attendance_cubit.dart';

class AttendancePage extends StatelessWidget {
  final bool showReport;
  const AttendancePage({super.key, this.showReport = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(showReport ? 'Laporan Kehadiran' : 'Kehadiran'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white),
      body: BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, s) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- Absen hari ini (check-in / check-out di sini) ---
            Container(
              decoration: AppStyles.card,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.fingerprint,
                          color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Absen Hari Ini',
                          style: AppStyles.h3),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                          child: _jamBox(
                              'Masuk',
                              s.jamMasuk ?? '--:--')),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _jamBox(
                              'Keluar',
                              s.jamKeluar ?? '--:--')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: s.sudahCheckIn
                              ? null
                              : () => context
                                  .read<
                                      AttendanceCubit>()
                                  .checkIn(),
                          icon: const Icon(Icons.login,
                              size: 18),
                          label: Text(s.sudahCheckIn
                              ? 'Sudah Check-In'
                              : 'Check-In'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: (!s.sudahCheckIn ||
                                  s.sudahCheckOut)
                              ? null
                              : () => context
                                  .read<
                                      AttendanceCubit>()
                                  .checkOut(),
                          icon: const Icon(
                              Icons.logout,
                              size: 18),
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
            const SizedBox(height: 16),
            Container(
              decoration: AppStyles.card,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat('${s.totalHadirBulanIni}', 'Hadir\nBulan Ini'),
                  _stat('${s.totalTerlambat}', 'Terlambat'),
                  _stat('95%', 'Kehadiran'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: AppStyles.card,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Minggu Ini', style: AppStyles.h3),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: s.mingguIni
                        .map((h) => Column(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: h.hadir
                                        ? AppColors.primary
                                        : AppColors.border,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                      h.hadir
                                          ? Icons.check
                                          : Icons.close,
                                      color: h.hadir
                                          ? Colors.white
                                          : AppColors.textGrey,
                                      size: 18),
                                ),
                                const SizedBox(height: 4),
                                Text(h.hari,
                                    style: AppStyles.caption),
                              ],
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: AppStyles.card,
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Riwayat', style: AppStyles.h3),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.login,
                          color: AppColors.success),
                      title: Text('Check-In 07:58'),
                      subtitle: Text('Senin, 29 Sep 2026')),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.login,
                          color: AppColors.success),
                      title: Text('Check-In 08:05'),
                      subtitle: Text('Jumat, 26 Sep 2026')),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.logout,
                          color: AppColors.warning),
                      title: Text('Check-Out 17:02'),
                      subtitle: Text('Jumat, 26 Sep 2026')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jamBox(String label, String jam) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.infoBg,
          borderRadius: BorderRadius.circular(20),
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

  Widget _stat(String v, String l) => Column(
        children: [
          Text(v,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
          Text(l,
              textAlign: TextAlign.center,
              style: AppStyles.caption),
        ],
      );
}
