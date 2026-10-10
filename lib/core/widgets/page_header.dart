import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/notification/bloc/notification_cubit.dart';
import '../../features/notification/view/notification_page.dart';
import '../theme/app_colors.dart';

/// Header atas ala Beranda untuk semua tab:
/// nama halaman + lonceng notifikasi sebaris.
class PageHeader extends StatelessWidget {
  final String title;
  const PageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Tinggi disamakan dengan header profil beranda (52px).
    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
          ),
          Positioned(
            right: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () =>
                  showNotificationPopup(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: 0.2),
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
                    backgroundColor:
                        AppColors.danger,
                    child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
