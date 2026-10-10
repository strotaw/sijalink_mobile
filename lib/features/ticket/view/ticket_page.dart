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
      appBar: AppBar(title: const Text('Ticketing')),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, s) => Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: ['Semua', 'Baru', 'Proses', 'Selesai']
                    .map((f) => Padding(
                          padding:
                              const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(f),
                            selected: s.filter == f,
                            selectedColor:
                                AppColors.infoBg,
                            shape: const StadiumBorder(
                                side: BorderSide(
                                    color: AppColors
                                        .border)),
                            onSelected: (_) => context
                                .read<TicketCubit>()
                                .setFilter(f),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: s.filtered.length,
                itemBuilder: (_, i) {
                  final t = s.filtered[i];
                  return Container(
                    margin:
                        const EdgeInsets.only(bottom: 10),
                    decoration: AppStyles.card,
                    child: ListTile(
                      leading: Container(
                        padding:
                            const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColors.infoBg,
                            borderRadius:
                                BorderRadius.circular(
                                    16)),
                        child: const Icon(
                            Icons
                                .confirmation_number_outlined,
                            color:
                                AppColors.primary),
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
                              .read<NotificationCubit>()
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
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                              value:
                                  TicketStatus.proses,
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
          ],
        ),
      ),
    );
  }
}
