import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../mikrotik/bloc/mikrotik_cubit.dart';

class MikrotikPage extends StatelessWidget {
  const MikrotikPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
          title: const Text('Mikrotik di Manage'),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(
                  16, 12, 16, 10),
              child: BlocBuilder<MikrotikCubit,
                  MikrotikState>(
                builder: (context, s) => Row(
                  children: ['Semua', 'Online', 'Offline']
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
                                  .read<MikrotikCubit>()
                                  .setFilter(f),
                            ),
                          ))
                      .toList(),
                ),
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
                child: BlocBuilder<MikrotikCubit,
                    MikrotikState>(
                  builder: (context, s) =>
                      ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: s.filtered.length,
                    itemBuilder: (_, i) {
                      final m = s.filtered[i];
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 12),
                        decoration:
                            AppStyles.card.copyWith(
                          border: Border.all(
                            color: AppColors.border,
                            width: 2,
                          ),
                        ),
                        padding:
                            const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.router,
                                    color: m.online
                                        ? AppColors.success
                                        : AppColors
                                            .danger),
                                const SizedBox(
                                    width: 8),
                                Text(m.nama,
                                    style:
                                        AppStyles.h3),
                                const Spacer(),
                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                              horizontal:
                                                  12,
                                              vertical:
                                                  6),
                                  decoration:
                                      BoxDecoration(
                                          color: m.online
                                              ? AppColors
                                                  .successBg
                                              : AppColors
                                                  .dangerBg,
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      100)),
                                  child: Text(
                                      m.online
                                          ? 'Online'
                                          : 'Offline',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                          color: m.online
                                              ? AppColors
                                                  .success
                                              : AppColors
                                                  .danger)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                                'IP: ${m.ip}  •  Uptime: ${m.uptime}',
                                style:
                                    AppStyles.caption),
                            Text(
                                'Client: ${m.clientCount}',
                                style:
                                    AppStyles.caption),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
