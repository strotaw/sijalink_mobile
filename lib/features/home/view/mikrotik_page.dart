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
      appBar: AppBar(
          title: const Text('Mikrotik di Manage'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white),
      body: BlocBuilder<MikrotikCubit, MikrotikState>(
        builder: (context, s) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: s.list.length,
          itemBuilder: (_, i) {
            final m = s.list[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: AppStyles.card,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.router,
                          color: m.online
                              ? AppColors.success
                              : AppColors.danger),
                      const SizedBox(width: 8),
                      Text(m.nama, style: AppStyles.h3),
                      const Spacer(),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4),
                        decoration: BoxDecoration(
                            color: (m.online
                                    ? AppColors.success
                                    : AppColors.danger)
                                .withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(
                                    20)),
                        child: Text(
                            m.online
                                ? 'Online'
                                : 'Offline',
                            style: TextStyle(
                                fontSize: 11,
                                color: m.online
                                    ? AppColors.success
                                    : AppColors.danger)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('IP: ${m.ip}  •  Uptime: ${m.uptime}',
                      style: AppStyles.caption),
                  Text('Client: ${m.clientCount}',
                      style: AppStyles.caption),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
