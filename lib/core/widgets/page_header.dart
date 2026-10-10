import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../teknisi/notification/bloc/notification_cubit.dart';
import '../../teknisi/notification/view/notification_page.dart';
import '../theme/app_colors.dart';
import '../theme/responsive.dart';

/// Header atas ala Beranda untuk semua tab:
/// nama halaman + lonceng notifikasi sebaris.
class PageHeader extends StatelessWidget {
  final String title;
  const PageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Tinggi disamakan dengan header profil beranda.
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.rs(12)),
      child: SizedBox(
        height: context.rs(52),
        child: _HeaderBody(title: title),
      ),
    );
  }
}

class _HeaderBody extends StatelessWidget {
  final String title;
  const _HeaderBody({required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: context.rs(20),
                  fontWeight: FontWeight.w700)),
        ),
        Positioned(
          right: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () =>
                showNotificationPopup(context),
            child: Container(
              padding: EdgeInsets.all(
                  context.rs(10)),
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
                  child: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: context.rs(24)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
