import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../attendance/bloc/attendance_cubit.dart';

/// Batas jam masuk buat hitung keterlambatan.
/// Masih statis — nanti ganti dari config / backend.
const String kBatasMasuk = '08:00';

/// Menit sejak tengah malam dari string "HH:mm".
/// Balikin -1 kalau formatnya nggak valid.
int _menitDariJam(String jam) {
  final bagian = jam.split(':');
  final h = int.tryParse(bagian.isNotEmpty ? bagian[0].trim() : '');
  final m = int.tryParse(bagian.length > 1 ? bagian[1].trim() : '');
  if (h == null || m == null) return -1;
  return h * 60 + m;
}

/// Selisih menit check-in terhadap [kBatasMasuk].
/// Positif = terlambat, 0/negatif = tepat waktu,
/// null = jam nggak valid.
int? hitungTerlambatMenit(String jamMasuk) {
  final masuk = _menitDariJam(jamMasuk);
  final batas = _menitDariJam(kBatasMasuk);
  if (masuk < 0 || batas < 0) return null;
  return masuk - batas;
}

/// Teks durasi terlambat: "15 menit" atau "1 jam 5 menit".
String teksTerlambat(int menit) {
  if (menit < 60) return '$menit menit';
  final jam = menit ~/ 60;
  final sisa = menit % 60;
  return sisa == 0 ? '$jam jam' : '$jam jam $sisa menit';
}

/// Detail satu hari presensi: jam masuk/keluar, keterangan
/// izin, foto, dan status terlambat vs batas [kBatasMasuk].
class AttendanceDetailPage extends StatelessWidget {
  final DateTime tanggal;
  final List<PresensiRecord> records;

  const AttendanceDetailPage({
    super.key,
    required this.tanggal,
    required this.records,
  });

  PresensiRecord? _cari(PresensiJenis j) {
    for (final r in records) {
      if (r.jenis == j) return r;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final masuk = _cari(PresensiJenis.checkIn);
    final pulang = _cari(PresensiJenis.checkOut);
    final izin = _cari(PresensiJenis.izin);
    final terlambat =
        masuk == null ? null : hitungTerlambatMenit(masuk.jam);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
          title: const Text('Detail Presensi'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 16),
            // Kartu tanggal.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: AppStyles.card,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_tgl(tanggal),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    Text('Batas masuk: $kBatasMasuk',
                        style: AppStyles.caption),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Status terlambat / tepat waktu / izin.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _statusKartu(masuk, izin, terlambat),
            ),
            const SizedBox(height: 12),
            // Rincian jam + foto.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: AppStyles.card,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rincian',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    if (masuk != null)
                      _baris(Icons.login, AppColors.success,
                          'Check-In', masuk.jam),
                    if (pulang != null)
                      _baris(Icons.logout, AppColors.warning,
                          'Check-Out', pulang.jam),
                    if (izin != null)
                      _baris(Icons.medical_services_outlined,
                          AppColors.info,
                          izin.keterangan ?? 'Izin', izin.jam),
                    if (masuk == null &&
                        pulang == null &&
                        izin == null)
                      Text('Belum ada presensi hari ini',
                          style: AppStyles.caption),
                    if ((masuk?.fotoPath ?? pulang?.fotoPath) !=
                        null) ...[
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(16),
                        child: Image.file(
                            File(masuk?.fotoPath ??
                                pulang!.fotoPath!),
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Kartu status: merah terlambat, hijau tepat waktu,
  /// biru kalau hari itu izin.
  Widget _statusKartu(
      PresensiRecord? masuk, PresensiRecord? izin, int? terlambat) {
    if (izin != null) {
      return _kartuStatus(
        bg: AppColors.infoBg,
        warna: AppColors.info,
        icon: Icons.medical_services_outlined,
        judul: izin.keterangan ?? 'Izin',
        teks: 'Tidak dihitung terlambat — ada pengajuan izin.',
      );
    }
    if (masuk == null || terlambat == null) {
      return _kartuStatus(
        bg: AppColors.infoBg,
        warna: AppColors.info,
        icon: Icons.help_outline,
        judul: 'Belum ada check-in',
        teks: 'Status terlambat belum bisa dihitung.',
      );
    }
    if (terlambat > 0) {
      return _kartuStatus(
        bg: AppColors.dangerBg,
        warna: AppColors.danger,
        icon: Icons.schedule,
        judul: 'Terlambat ${teksTerlambat(terlambat)}',
        teks:
            'Masuk ${masuk.jam} — batas masuk $kBatasMasuk.',
      );
    }
    return _kartuStatus(
      bg: AppColors.successBg,
      warna: AppColors.success,
      icon: Icons.check_circle_outline,
      judul: 'Tepat Waktu',
      teks: 'Masuk ${masuk.jam} — batas masuk $kBatasMasuk.',
    );
  }

  Widget _kartuStatus({
    required Color bg,
    required Color warna,
    required IconData icon,
    required String judul,
    required String teks,
  }) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: warna, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(judul,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: warna)),
                  const SizedBox(height: 2),
                  Text(teks,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textDark)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _baris(
      IconData icon, Color warna, String label, String jam) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: warna, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(label, style: AppStyles.caption)),
          Text(jam,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }

  String _tgl(DateTime d) {
    const hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    const bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${hari[d.weekday - 1]}, ${d.day} ${bulan[d.month - 1]} ${d.year}';
  }
}
