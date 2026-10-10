import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/responsive.dart';
import '../../attendance/bloc/attendance_cubit.dart';
import '../../notification/bloc/notification_cubit.dart';
import '../../notification/view/notification_page.dart';
import '../../../core/widgets/profile_avatar.dart';
import '../../../core/widgets/sheet_page.dart';
import '../../profile/bloc/profile_cubit.dart';
import '../../ticket/bloc/ticket_cubit.dart';
import 'attendance_page.dart';
import 'mikrotik_page.dart';
import 'spk_page.dart';
import '../../ticket/view/ticket_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) =>
            SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(vertical: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 32,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 12),
                    child:
                        _profileHeader(context),
                  ),
                  const SizedBox(height: 52),
                  // Panel kehadiran — terpisah dengan jarak.
                  Container(
                      width: double.infinity,
                      margin:
                          const EdgeInsets.symmetric(
                              horizontal: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                                28),
                      ),
                      padding:
                          const EdgeInsets.all(16),
                      child:
                          _kehadiranRow(context),
                    ),
                  // Panel menu pas mengisi sisa layar —
                  // tidak bisa di-scroll.
                  const SizedBox(height: 60),
                  Expanded(
                    child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                          Color(0xFF2AA5CD),
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                      borderRadius:
                          const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                        bottomLeft:
                            Radius.circular(50),
                        bottomRight:
                            Radius.circular(50),
                      ),
                    ),
                    padding:
                        const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          const Center(
                            child: Text('Menu Teknisi',
                                style: AppStyles.h3),
                          ),
                          const SizedBox(height: 28),
                          const _MenuCarousel(),
                          const Divider(
                              height: 48,
                              thickness: 1),
                          _tiketAktif(context),
                        ],
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Foto profil kiri atas + sapaan kecil + lonceng notifikasi sebaris.
  Widget _profileHeader(BuildContext context) => Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white, width: 2),
            ),
            child: BlocBuilder<ProfileCubit,
                ProfileState>(
              builder: (context, p) =>
                  ProfileAvatar(
                      profile: p,
                      radius: context.rs(24)),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text('Halo 👋',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12)),
                Text('Teknisi Dika',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () =>
                showNotificationPopup(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    Colors.white.withValues(alpha: 0.2),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: BlocBuilder<NotificationCubit,
                  NotificationState>(
                builder: (context, n) => Badge(
                  isLabelVisible:
                      n.unreadCount > 0,
                  label:
                      Text('${n.unreadCount}'),
                  backgroundColor: AppColors.danger,
                  child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      );

  /// "Jumat, 10 Oktober 2026" dalam Bahasa Indonesia.
  String _hariTanggal() {
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
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    final now = DateTime.now();
    return '${hari[now.weekday - 1]}, ${now.day} '
        '${bulan[now.month - 1]} ${now.year}';
  }

  /// Ringkasan saja — absen dilakukan di halaman Kehadiran.
  /// Atas: hari + tanggal. Bawah: ikon ✓/✗ + "Check-In"
  /// + jam presensi / "Belum presensi".
  Widget _kehadiranRow(BuildContext context) =>
      BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, s) => InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => bukaHalamanSheet(
              context, const AttendancePage()),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 4),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(_hariTanggal(),
                    style: AppStyles.h3),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: s.sudahCheckIn
                            ? AppColors.successBg
                            : AppColors.dangerBg,
                        borderRadius:
                            BorderRadius.circular(
                                20),
                      ),
                      child: Icon(
                        s.sudahCheckIn
                            ? Icons.check_rounded
                            : Icons.close_rounded,
                        color: s.sudahCheckIn
                            ? AppColors.success
                            : AppColors.danger,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text('Check-In',
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                  fontSize: 14,
                                  color: AppColors
                                      .textDark)),
                          const SizedBox(height: 2),
                          Text(
                            s.sudahCheckIn
                                ? (s.jamMasuk ??
                                    '--:--')
                                : 'Belum presensi',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w700,
                              color: s.sudahCheckIn
                                  ? AppColors
                                      .primary
                                  : AppColors
                                      .textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textGrey),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  /// Bubble tiket sendiri di dalam panel teknisi —
  /// hanya 1 tiket terbaru + tombol ke halaman Ticketing.
  Widget _tiketAktif(BuildContext context) =>
      BlocBuilder<TicketCubit, TicketState>(
        builder: (context, s) {
          final aktif = s.aktif;
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 40),
            // Satu bubble gabung: kepala biru + badan putih.
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(24),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color:
                        const Color(0xFF0C70A4),
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4),
                    child: Row(
                      children: [
                        const Text('Tiket Aktif',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight:
                                    FontWeight
                                        .w700)),
                        const Spacer(),
                        TextButton(
                            onPressed: () =>
                                bukaHalamanSheet(
                                    context,
                                    const TicketPage()),
                            style: TextButton
                                .styleFrom(
                              foregroundColor:
                                  Colors.white,
                            ),
                            child: const Text(
                                'Lihat Semua')),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                if (aktif.isEmpty)
                  const Text(
                      'Tidak ada tiket aktif',
                      style: AppStyles.caption)
                else
                  Builder(builder: (_) {
                    final t = aktif.first;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding:
                            const EdgeInsets.all(
                                10),
                        decoration: BoxDecoration(
                            color: AppColors.infoBg,
                            borderRadius:
                                BorderRadius.circular(
                                    16)),
                        child: const Icon(
                            Icons
                                .confirmation_number_outlined,
                            color: AppColors.primary,
                            size: 20),
                      ),
                      title: Text(
                          '${t.no} • ${t.judul}',
                          style: const TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                              fontSize: 13)),
                      subtitle: Text(t.customer,
                          style: AppStyles.caption),
                      trailing:
                          _tiketBadge(t.status),
                    );
                  }),
                  ],
                ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget _tiketBadge(TicketStatus s) {
    final (txt, c, bg) = switch (s) {
      TicketStatus.baru => ('Baru', AppColors.info, AppColors.infoBg),
      TicketStatus.proses =>
        ('Proses', AppColors.warning, AppColors.warningBg),
      TicketStatus.selesai =>
        ('Selesai', AppColors.success, AppColors.successBg),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100)),
      child: Text(txt,
          style: TextStyle(
              color: c,
              fontSize: 11,
              fontWeight: FontWeight.w700)),
    );
  }
}

/// Carousel 5 tombol: muat 4 di layar, bisa digeser.
/// Panah kiri hilang saat mentok kiri, panah kanan hilang
/// saat mentok kanan.
class _MenuCarousel extends StatefulWidget {
  const _MenuCarousel();

  @override
  State<_MenuCarousel> createState() => _MenuCarouselState();
}

class _MenuCarouselState extends State<_MenuCarousel> {
  final _scroll = ScrollController();
  bool _atStart = true;
  bool _atEnd = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    setState(() {
      _atStart = _scroll.offset <= 8;
      _atEnd =
          max <= 0 || _scroll.offset >= max - 8;
    });
  }

  // Langkah snap = 1 ikon (diisi dinamis di build
  // agar 4 ikon pas selebar list).
  double _step = 64.0 + 8.0;

  void _geser(int arah) {
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    final index =
        (_scroll.offset / _step).round() + arah;
    final target =
        (index * _step).clamp(0.0, max);
    _scroll.animateTo(target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    // Panah punya slot tetap 34px di tiap tepi (kosong
    // saat mentok) sehingga tidak menutupi ikon dan
    // lebar list stabil.
    return SizedBox(
      height: context.rs(100),
      child: Row(
        children: [
          SizedBox(
            width: context.rs(30),
            child: _atStart
                ? null
                : _panah(
                    context,
                    Icons.chevron_left_rounded,
                    () => _geser(-1)),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                // 4 ikon pas selebar list: jarak dihitung
                // dinamis dari lebar layar (diskala responsif).
                final itemW = context.rs(64);
                final lebarList =
                    MediaQuery.of(context)
                        .size
                        .width -
                        32 -
                        context.rs(60);
                final s =
                    ((lebarList - itemW * 4) / 3)
                        .clamp(4.0, 40.0);
                _step = itemW + s;
                final lebar4 =
                    itemW * 4 + s * 3;
                final pad =
                    ((lebarList - lebar4) / 2)
                        .clamp(0.0, 80.0);
                return ListView(
                  controller: _scroll,
                  scrollDirection:
                      Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                      horizontal: pad),
                  children: [
                    _item(
                        context,
                        Icons.fingerprint,
                        'Kehadiran',
                        const AttendancePage(),
                        s),
                    _item(
                        context,
                        Icons.assessment_rounded,
                        'Laporan Kehadiran',
                        const AttendancePage(
                            showReport: true),
                        s),
                    _item(
                        context,
                        Icons.assignment_rounded,
                        'SPK',
                        const SpkPage(),
                        s),
                    _item(
                        context,
                        Icons
                            .confirmation_number_outlined,
                        'Tiket',
                        const TicketPage(),
                        s),
                    _item(
                        context,
                        Icons.router_rounded,
                        'Mikrotik',
                        const MikrotikPage(),
                        s),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            width: context.rs(30),
            child: _atEnd
                ? null
                : _panah(
                    context,
                    Icons.chevron_right_rounded,
                    () => _geser(1)),
          ),
        ],
      ),
    );
  }

  Widget _panah(BuildContext context, IconData icon,
      VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.rs(2)),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: Container(
          width: context.rs(26),
          height: context.rs(26),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: Colors.white,
              size: context.rs(18)),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon,
      String label, Widget page, double jarak,
      {bool sheet = true}) {
    // Hanya "Laporan Kehadiran" yang labelnya 2 baris
    // dan butuh kotak tinggi.
    final duaBaris = label == 'Laporan Kehadiran';
    return Padding(
      padding: EdgeInsets.only(right: jarak),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => sheet
            ? bukaHalamanSheet(context, page)
            : Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => page)),
        child: SizedBox(
          width: context.rs(64),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.rs(2),
                vertical: context.rs(6)),
            // Rata atas: ikon sejajar ikon, teks sejajar teks.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                Icon(icon,
                    color: AppColors.primary,
                    size: context.rs(44)),
                SizedBox(height: context.rs(6)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.rs(2),
                      vertical: context.rs(2)),
                  decoration: BoxDecoration(
                    color: AppColors.primary
                        .withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: duaBaris
                      ? SizedBox(
                          height: context.rs(30),
                          child: Text(label,
                              textAlign:
                                  TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow
                                  .ellipsis,
                              style: TextStyle(
                                  fontSize:
                                      context.rs(11),
                                  fontWeight:
                                      FontWeight.w600,
                                  color: AppColors
                                      .textDark)),
                        )
                      : Text(label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize:
                                  context.rs(11),
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  AppColors.textDark)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
