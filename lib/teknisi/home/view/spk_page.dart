import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../notification/bloc/notification_cubit.dart';
import '../../spk/bloc/spk_cubit.dart';

class SpkPage extends StatelessWidget {
  const SpkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
          title: const Text('Surat Perintah Kerja'),
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
        child: BlocBuilder<SpkCubit, SpkState>(
          builder: (context, s) => Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(
                    16, 12, 16, 10),
                child: Row(
                  children: ['Semua', 'Baru', 'Proses', 'Selesai']
                      .map((f) => Padding(
                            padding:
                                const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(f),
                              selected: s.filter == f,
                              selectedColor:
                                  AppColors.primaryDark,
                              backgroundColor:
                                  Colors.white,
                              checkmarkColor:
                                  Colors.white,
                              labelStyle: TextStyle(
                                color: s.filter == f
                                    ? Colors.white
                                    : AppColors
                                        .primaryDark,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                              shape: const StadiumBorder(
                                  side: BorderSide.none),
                              onSelected: (_) => context
                                  .read<SpkCubit>()
                                  .setFilter(f),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: s.filtered.length,
                    itemBuilder: (_, i) {
                      final spk = s.filtered[i];
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 10),
                        decoration:
                            AppStyles.card.copyWith(
                          border: Border.all(
                            color: AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding:
                                const EdgeInsets.all(
                                    10),
                            decoration: BoxDecoration(
                                color: _statusBg(spk.status),
                                borderRadius:
                                    BorderRadius.circular(
                                        16)),
                            child: Icon(
                                _statusIcon(spk.status),
                                color: _statusColor(
                                    spk.status)),
                          ),
                          title: Text(
                              '${spk.no} • ${spk.jenis}',
                              style: const TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                  fontSize: 13)),
                          subtitle: Text(
                              '${spk.customer}\n${spk.alamat}',
                              style: AppStyles.caption),
                          isThreeLine: true,
                          trailing: PopupMenuButton<
                              SpkStatus>(
                            icon: const Icon(
                                Icons.more_vert),
                            onSelected: (st) {
                              context
                                  .read<SpkCubit>()
                                  .updateStatus(
                                      spk.no, st);
                              context
                                  .read<
                                      NotificationCubit>()
                                  .pushSpk(
                                    spk.no,
                                    spk.jenis,
                                    st ==
                                            SpkStatus
                                                .selesai
                                        ? NotifType
                                            .spkSelesai
                                        : NotifType
                                            .spkProses,
                                  );
                              ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${spk.no} → ${st.name}'),
                                  behavior:
                                      SnackBarBehavior
                                          .floating,
                                  shape:
                                      const StadiumBorder(),
                                ),
                              );
                            },
                            itemBuilder: (_) =>
                                const [
                              PopupMenuItem(
                                  value: SpkStatus
                                      .proses,
                                  child: Text(
                                      'Mulai Kerjakan')),
                              PopupMenuItem(
                                  value: SpkStatus
                                      .selesai,
                                  child: Text(
                                      'Selesaikan')),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _statusIcon(SpkStatus st) {
  switch (st) {
    case SpkStatus.baru:
      return Icons.assignment;
    case SpkStatus.proses:
      return Icons.build; // kunci inggris
    case SpkStatus.selesai:
      return Icons.check_circle_outline;
  }
}

Color _statusColor(SpkStatus st) {
  switch (st) {
    case SpkStatus.baru:
      return AppColors.primary;
    case SpkStatus.proses:
      return AppColors.warning;
    case SpkStatus.selesai:
      return AppColors.success;
  }
}

Color _statusBg(SpkStatus st) {
  switch (st) {
    case SpkStatus.baru:
      return AppColors.infoBg;
    case SpkStatus.proses:
      return AppColors.warningBg;
    case SpkStatus.selesai:
      return AppColors.successBg;
  }
}
