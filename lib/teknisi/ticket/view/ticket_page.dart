import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../notification/bloc/notification_cubit.dart';
import '../bloc/ticket_cubit.dart';

class TicketPage extends StatelessWidget {
  const TicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
          title: const Text('Ticketing'),
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
        child: BlocBuilder<TicketCubit, TicketState>(
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
                                  .read<TicketCubit>()
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
                      final t = s.filtered[i];
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
                                color: _statusBg(t.status),
                                borderRadius:
                                    BorderRadius.circular(
                                        16)),
                            child: Icon(
                                _statusIcon(t.status),
                                color: _statusColor(
                                    t.status)),
                          ),
                          title: Text(
                              '${t.no} • ${t.judul}',
                              style: const TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                  fontSize: 13)),
                          subtitle: Text(
                              '${t.customer}\nPrioritas: ${t.prioritas}',
                              style: AppStyles.caption),
                          isThreeLine: true,
                          trailing: PopupMenuButton<
                              TicketStatus>(
                            icon: const Icon(
                                Icons.more_vert),
                            onSelected: (st) {
                              context
                                  .read<TicketCubit>()
                                  .updateStatus(
                                      t.no, st);
                              context
                                  .read<
                                      NotificationCubit>()
                                  .pushSpk(
                                    t.no,
                                    t.judul,
                                    st ==
                                            TicketStatus
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
                                      '${t.no} → ${st.name}'),
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
                                  value: TicketStatus
                                      .proses,
                                  child: Text(
                                      'Mulai Kerjakan')),
                              PopupMenuItem(
                                  value: TicketStatus
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

IconData _statusIcon(TicketStatus st) {
  switch (st) {
    case TicketStatus.baru:
      return Icons.confirmation_number_outlined;
    case TicketStatus.proses:
      return Icons.build; // kunci inggris
    case TicketStatus.selesai:
      return Icons.check_circle_outline;
  }
}

Color _statusColor(TicketStatus st) {
  switch (st) {
    case TicketStatus.baru:
      return AppColors.primary;
    case TicketStatus.proses:
      return AppColors.warning;
    case TicketStatus.selesai:
      return AppColors.success;
  }
}

Color _statusBg(TicketStatus st) {
  switch (st) {
    case TicketStatus.baru:
      return AppColors.infoBg;
    case TicketStatus.proses:
      return AppColors.warningBg;
    case TicketStatus.selesai:
      return AppColors.successBg;
  }
}
