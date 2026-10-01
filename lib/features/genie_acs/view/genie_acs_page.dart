import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/genie_acs_cubit.dart';

class GenieAcsPage extends StatelessWidget {
  const GenieAcsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenieAcsCubit, GenieAcsState>(
      builder: (context, s) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.primary,
                AppColors.primaryDark
              ]),
              borderRadius:
                  BorderRadius.all(Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.cloud_done_rounded,
                    color: Colors.white, size: 36),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text('${s.onlineCount}/${s.devices.length} Online',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18)),
                    const Text('GenieACS Server: acs.sijalink.id',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final d in s.devices)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: AppStyles.card,
              child: ListTile(
                leading: Icon(Icons.wifi,
                    color: d.online
                        ? AppColors.success
                        : AppColors.textGrey),
                title: Text(d.model,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                subtitle: Text(
                    '${d.serial}\n${d.customer}',
                    style: AppStyles.caption),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: d.online
                      ? () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content: Text(
                                      'Reboot dikirim ke ${d.serial}')));
                        }
                      : null,
                  child: const Text('Reboot'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
