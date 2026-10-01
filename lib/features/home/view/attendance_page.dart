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
