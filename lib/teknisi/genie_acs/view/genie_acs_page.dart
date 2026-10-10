import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/page_header.dart';
import '../bloc/genie_acs_cubit.dart';

class GenieAcsPage extends StatefulWidget {
  const GenieAcsPage({super.key});

  @override
  State<GenieAcsPage> createState() =>
      _GenieAcsPageState();
}

class _GenieAcsPageState extends State<GenieAcsPage> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

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
      child: BlocBuilder<GenieAcsCubit, GenieAcsState>(
        builder: (context, s) => Column(
          children: [
            const SizedBox(height: 66),
            const PageHeader(title: 'GenieACS'),
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 40),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_done_rounded,
                      color: AppColors.primary, size: 36),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text('${s.onlineCount}/${s.devices.length} Online',
                          style: const TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 18)),
                      const Text('GenieACS Server: acs.sijalink.id',
                          style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Panel list device mentok ke bawah, list
            // scroll di dalamnya.
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Scrollbar(
                  controller: _scroll,
                  thumbVisibility: true,
                  thickness: 6,
                  radius:
                      const Radius.circular(100),
                  child: ListView.builder(
                    controller: _scroll,
                    padding: EdgeInsets.zero,
                    itemCount: s.devices.length,
                  itemBuilder: (_, i) {
                    final d = s.devices[i];
                    return Container(
                      margin:
                          const EdgeInsets.only(bottom: 10),
                      decoration: AppStyles.card,
                      child: ListTile(
                        leading: ConstrainedBox(
                          constraints:
                              const BoxConstraints(
                                  minHeight: 72),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi,
                                  color: d.online
                                      ? AppColors.success
                                      : AppColors
                                          .textGrey),
                            ],
                          ),
                        ),
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
                                  ScaffoldMessenger.of(
                                          context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                              'Reboot dikirim ke ${d.serial}')));
                                }
                              : null,
                          child: const Text('Reboot'),
                        ),
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
