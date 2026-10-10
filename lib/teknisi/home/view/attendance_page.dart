import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/storage/asset_storage.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/responsive.dart';
import '../../attendance/bloc/attendance_cubit.dart';

class AttendancePage extends StatefulWidget {
  final bool showReport;
  const AttendancePage({super.key, this.showReport = false});

  @override
  State<AttendancePage> createState() =>
      _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _lapScroll = ScrollController();

  bool get showReport => widget.showReport;

  @override
  void dispose() {
    _lapScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
          title: Text(showReport ? 'Laporan Kehadiran' : 'Kehadiran'),
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
        child: Column(
          children: [
            // Ruang untuk separuh tombol foto (mode absen).
            if (!showReport)
              SizedBox(height: context.rs(72)),
            if (showReport)
              SizedBox(height: context.rs(16)),
            Expanded(
              child: BlocBuilder<AttendanceCubit,
                  AttendanceState>(
                builder: (context, s) => showReport
                    ? _panelLaporan(context, s)
                    : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Panel mentok bawah, atas round 30px.
                    Positioned.fill(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius:
                              BorderRadius.only(
                            topLeft:
                                Radius.circular(30),
                            topRight:
                                Radius.circular(30),
                          ),
                        ),
                        padding:
                            EdgeInsets.fromLTRB(
                                20, context.rs(72), 20, 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: _jamBox(
                                          'Masuk',
                                          s.izinHariIni !=
                                                  null
                                              ? (s.izinTipe ??
                                                  'Izin')
                                              : (s.jamMasuk ??
                                                  '--:--'),
                                          s.fotoMasuk)),
                                  const SizedBox(
                                      width: 10),
                                  Expanded(
                                      child: _jamBox(
                                          'Keluar',
                                          s.izinHariIni !=
                                                  null
                                              ? (s.izinTipe ??
                                                  'Izin')
                                              : (s.jamKeluar ??
                                                  '--:--'),
                                          s.fotoKeluar)),
                                ],
                              ),
                              const SizedBox(
                                  height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton
                                    .icon(
                                  style: ElevatedButton
                                      .styleFrom(
                                          backgroundColor:
                                              Colors.white,
                                          foregroundColor:
                                              AppColors
                                                  .primary),
                                  onPressed: (s.sudahCheckIn ||
                                          s.izinHariIni !=
                                              null)
                                      ? null
                                      : () => _formIzin(
                                          context),
                                  icon: const Icon(
                                      Icons
                                          .medical_services_outlined,
                                      size: 18),
                                  label: const Text(
                                      'Izin'),
                                ),
                              ),
                              if (s.izinHariIni !=
                                  null) ...[
                                const SizedBox(
                                    height: 12),
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                              horizontal:
                                                  14,
                                              vertical:
                                                  10),
                                  decoration:
                                      BoxDecoration(
                                    color: AppColors
                                        .warningBg,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                20),
                                  ),
                                  child: Text(
                                      'Keterangan: ${s.izinHariIni}',
                                      style:
                                          const TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                              color: AppColors
                                                  .warning)),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Tombol foto bulet: setengah di luar panel.
                    Positioned(
                      top: -context.rs(60),
                      left: 0,
                      right: 0,
                      child: Center(
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(
                                  100),
                          onTap: () =>
                              _aksiFoto(context, s),
                          child: Container(
                            padding:
                                const EdgeInsets.all(
                                    3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white,
                                  width: 2),
                            ),
                            child: _avatarFoto(
                                context, s),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Avatar tombol foto: tampilkan foto masuk bila sudah
  /// check-in, sonst ikon kamera.
  Widget _avatarFoto(BuildContext context, AttendanceState s) {
    final r = context.rs(60);
    if (s.fotoMasuk != null && !s.sudahCheckOut) {
      return CircleAvatar(
        radius: r,
        backgroundImage:
            FileImage(File(s.fotoMasuk!)),
      );
    }
    if (s.fotoKeluar != null) {
      return CircleAvatar(
        radius: r,
        backgroundImage:
            FileImage(File(s.fotoKeluar!)),
      );
    }
    return CircleAvatar(
      radius: r,
      backgroundColor: AppColors.primary,
      child: Icon(Icons.camera_alt_rounded,
          color: Colors.white, size: context.rs(44)),
    );
  }

  /// Aksi tombol foto: check-in bila belum, check-out
  /// bila sudah check-in, info bila sudah lengkap.
  void _aksiFoto(
      BuildContext context, AttendanceState s) {
    if (!s.sudahCheckIn && s.izinHariIni == null) {
      _fotoDulu(context, masuk: true);
    } else if (s.sudahCheckIn && !s.sudahCheckOut) {
      _fotoDulu(context, masuk: false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Absen hari ini sudah lengkap'),
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder(),
        ),
      );
    }
  }

  /// Kotak jam ala versi sebelumnya: label + jam besar
  /// + thumbnail foto, putih di atas panel biru.
  Widget _jamBox(String label, String jam, String? foto) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey)),
            Text(jam,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            if (foto != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(12),
                child: Image.file(File(foto),
                    height: 64,
                    width: double.infinity,
                    fit: BoxFit.cover),
              ),
            ],
          ],
        ),
      );

  /// Panel laporan: rekap tanpa tombol absen —
  /// jumlah hadir, sakit, izin + riwayat per hari.
  Widget _panelLaporan(
      BuildContext context, AttendanceState s) {
    final sakit = s.riwayat
        .where((r) =>
            r.jenis == PresensiJenis.izin &&
            (r.keterangan ?? '').startsWith('Sakit'))
        .length;
    final grup = _perHari(s.riwayat);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ringkasan(context, s, sakit: sakit),
          const SizedBox(height: 16),
          const Text('Riwayat',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Expanded(
            child: Scrollbar(
              controller: _lapScroll,
              thumbVisibility: true,
              thickness: 6,
              radius:
                  const Radius.circular(100),
              child: ListView.builder(
                controller: _lapScroll,
                padding: EdgeInsets.zero,
                itemCount: grup.length,
                itemBuilder: (_, i) =>
                    _hariTile(grup[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Kelompokkan riwayat per tanggal (terbaru dulu).
  List<MapEntry<DateTime, List<PresensiRecord>>> _perHari(
      List<PresensiRecord> semua) {
    final map = <DateTime, List<PresensiRecord>>{};
    for (final r in semua) {
      final t = r.tanggal;
      final kunci = DateTime(t.year, t.month, t.day);
      map.putIfAbsent(kunci, () => []).add(r);
    }
    final entri = map.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    return entri;
  }

  /// Satu kartu hari: check-in jam X, check-out jam Y,
  /// atau keterangan izin.
  Widget _hariTile(
      MapEntry<DateTime, List<PresensiRecord>> grup) {
    PresensiRecord? pertama(PresensiJenis j) {
      for (final r in grup.value) {
        if (r.jenis == j) return r;
      }
      return null;
    }

    final masuk = pertama(PresensiJenis.checkIn);
    final pulang = pertama(PresensiJenis.checkOut);
    final izin = pertama(PresensiJenis.izin);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: AppStyles.card,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_tgl(grup.key),
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textDark)),
          const SizedBox(height: 8),
          if (masuk != null)
            _barisHari(Icons.login,
                AppColors.success, 'Check-In', masuk.jam),
          if (pulang != null)
            _barisHari(Icons.logout,
                AppColors.warning, 'Check-Out', pulang.jam),
          if (izin != null)
            _barisHari(
                Icons.medical_services_outlined,
                AppColors.info,
                izin.keterangan ?? 'Izin',
                izin.jam),
        ],
      ),
    );
  }

  Widget _barisHari(
      IconData icon, Color warna, String label, String jam) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, color: warna, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                style: AppStyles.caption),
          ),
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

  /// Ringkasan tanpa background/judul: kotak
  /// berwarna hijau (hadir), merah (sakit), kuning (izin).
  Widget _ringkasan(
      BuildContext context, AttendanceState s,
      {int? sakit}) {
    final hadir =
        s.riwayat.where((r) => r.jenis == PresensiJenis.checkIn).length;
    final izin =
        s.riwayat.where((r) => r.jenis == PresensiJenis.izin).length;
    return Row(
      children: [
        Expanded(
            child: _kotak(
                '$hadir', 'Hadir', AppColors.success)),
        const SizedBox(width: 10),
        Expanded(
            child: _kotak('${sakit ?? 0}', 'Sakit',
                AppColors.danger)),
        const SizedBox(width: 10),
        Expanded(
            child: _kotak('$izin', 'Izin',
                const Color(0xFFFFC107))),
      ],
    );
  }

  Widget _kotak(String nilai, String label, Color bg) {
    final gelap = bg == AppColors.warning ||
        bg == const Color(0xFFFFC107);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(nilai,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: gelap
                      ? AppColors.textDark
                      : Colors.white)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: gelap
                      ? AppColors.textDark
                      : Colors.white)),
        ],
      ),
    );
  }

  /// Wajib foto kamera dulu, lalu konfirmasi. Foto disalin
  /// ke folder upload agar permanen untuk riwayat; bila batal
  /// (Ulangi / tutup) salinannya langsung dihapus.
  Future<void> _fotoDulu(BuildContext context,
      {required bool masuk}) async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      imageQuality: 80,
    );
    if (file == null || !context.mounted) return;
    final penyimpanan = AssetStorage();
    final permanen = await penyimpanan.simpanFotoAbsen(
        file,
        prefix: masuk ? 'masuk' : 'keluar');
    if (!context.mounted) {
      await penyimpanan.hapusFile(permanen);
      return;
    }
    final yakinkah = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(24)),
        title: Text(masuk
            ? 'Konfirmasi Check-In'
            : 'Konfirmasi Check-Out'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(20),
              child: Image.file(File(permanen),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text(
                'Presensi pukul ${AttendanceCubit.jamSekarang()}',
                style: AppStyles.caption),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text('Ulangi')),
          ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text('Confirm')),
        ],
      ),
    );
    if (yakinkah != true || !context.mounted) {
      // Batal → file salinan tak terpakai, hapus.
      await penyimpanan.hapusFile(permanen);
      return;
    }
    if (masuk) {
      context
          .read<AttendanceCubit>()
          .checkIn(permanen);
    } else {
      context
          .read<AttendanceCubit>()
          .checkOut(permanen);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(masuk
            ? 'Check-In tercatat'
            : 'Check-Out tercatat'),
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
      ),
    );
  }

  /// Form pengajuan izin: pilih Sakit/Izin + keterangan
  /// wajib diisi, baru bisa Apply.
  Future<void> _formIzin(BuildContext context) async {
    String tipe = 'Sakit';
    final ket = TextEditingController();
    // Context halaman (tetap hidup setelah sheet di-pop).
    final halaman = context;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) => Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom +
                  24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text('Pengajuan Izin',
                  style: AppStyles.h2),
              const SizedBox(height: 12),
              Row(
                children: ['Sakit', 'Izin'].map((t) {
                  final aktif = tipe == t;
                  return Padding(
                    padding:
                        const EdgeInsets.only(
                            right: 8),
                    child: ChoiceChip(
                      label: Text(t),
                      selected: aktif,
                      selectedColor:
                          AppColors.primary,
                      labelStyle: TextStyle(
                          color: aktif
                              ? Colors.white
                              : AppColors.textDark,
                          fontWeight:
                              FontWeight.w600),
                      shape: const StadiumBorder(
                          side: BorderSide(
                              color:
                                  AppColors.border)),
                      onSelected: (_) =>
                          setSheet(() => tipe = t),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ket,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                      'Keterangan wajib diisi, mis. demam / urusan keluarga...',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (ket.text
                        .trim()
                        .isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Keterangan wajib diisi dulu'),
                          behavior: SnackBarBehavior
                              .floating,
                          shape: StadiumBorder(),
                        ),
                      );
                      return;
                    }
                    context
                        .read<AttendanceCubit>()
                        .ajukanIzin(
                            tipe, ket.text.trim());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(halaman)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                            'Izin ($tipe) diajukan'),
                        behavior: SnackBarBehavior
                            .floating,
                        shape:
                            const StadiumBorder(),
                      ),
                    );
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ket.dispose();
  }
}
