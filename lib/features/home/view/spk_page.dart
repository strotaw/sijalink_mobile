import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../spk/bloc/spk_cubit.dart';

class SpkPage extends StatelessWidget {
  const SpkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Surat Perintah Kerja'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white),
      body: BlocBuilder<SpkCubit, SpkState>(
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
                                AppColors.primaryLight,
                            onSelected: (_) => context
                                .read<SpkCubit>()
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
                  final spk = s.filtered[i];
                  return Container(
                    margin:
                        const EdgeInsets.only(bottom: 10),
                    decoration: AppStyles.card,
                    child: ListTile(
                      leading: Container(
                        padding:
                            const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColors
                                .primaryLight,
                            borderRadius:
                                BorderRadius.circular(
                                    10)),
                        child: const Icon(
                            Icons.assignment,
                            color:
                                AppColors.primary),
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
                        onSelected: (st) => context
                            .read<SpkCubit>()
                            .updateStatus(
                                spk.no, st),
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                              value:
                                  SpkStatus.proses,
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
          ],
        ),
      ),
    );
  }
}
