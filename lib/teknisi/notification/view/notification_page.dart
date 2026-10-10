import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/sheet_page.dart';
import '../../home/view/spk_page.dart';
import '../bloc/notification_cubit.dart';

/// Popup notifikasi SPK/Ticket — muncul menempel di bawah tombol
/// lonceng (pojok kanan atas), bukan bottom sheet / full screen.
Future<void> showNotificationPopup(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Tutup notifikasi',
    barrierColor: Colors.black26,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, anim, secondaryAnim) =>
        const _AnchoredPopup(),
    transitionBuilder: (context, anim, secondaryAnim, child) {
      final curved = CurvedAnimation(
          parent: anim, curve: Curves.easeOutBack);
      return ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1)
            .animate(curved),
        alignment: Alignment.topRight,
        child: FadeTransition(
            opacity: anim, child: child),
      );
    },
  );
}

class _AnchoredPopup extends StatelessWidget {
  const _AnchoredPopup();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final top = MediaQuery.of(context).padding.top + 64.0;
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(
              top: top, left: 16, right: 12),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: (size.width - 28)
                  .clamp(0.0, 380.0),
              constraints: BoxConstraints(
                maxHeight: size.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(28),
                border: Border.all(
                    color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary
                        .withValues(alpha: 0.25),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PopupHeader(),
                  Flexible(child: _PopupList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Header gradient ala "bg-gradient-to-r rounded-t-3xl".
class _PopupHeader extends StatelessWidget {
  const _PopupHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primarySoft,
            AppColors.primary,
            AppColors.primaryDark
          ],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: BlocBuilder<NotificationCubit,
          NotificationState>(
        builder: (context, s) {
          final cubit =
              context.read<NotificationCubit>();
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text('Notifikasi',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w700)),
                    Text(
                      s.unreadCount == 0
                          ? 'Semua sudah dibaca'
                          : '${s.unreadCount} belum dibaca',
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: cubit.markAllRead,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white
                      .withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12),
                ),
                child: const Text('Tandai dibaca',
                    style: TextStyle(fontSize: 11)),
              ),
              IconButton(
                onPressed: () =>
                    Navigator.pop(context),
                icon: const Icon(Icons.close_rounded,
                    color: Colors.white, size: 20),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PopupList extends StatelessWidget {
  const _PopupList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit,
        NotificationState>(
      builder: (context, s) {
        final cubit = context.read<NotificationCubit>();
        if (s.visible.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                    Icons
                        .notifications_off_outlined,
                    size: 52,
                    color: AppColors.textGrey),
                SizedBox(height: 12),
                Text('Tidak ada notifikasi',
                    style: AppStyles.h3),
                Text(
                    'SPK/tiket baru akan muncul di sini',
                    style: AppStyles.caption,
                    textAlign: TextAlign.center),
              ],
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          padding:
              const EdgeInsets.fromLTRB(12, 12, 12, 16),
          itemCount: s.visible.length,
          itemBuilder: (_, i) {
            final n = s.visible[i];
            return Dismissible(
              key: ValueKey(n.id),
              direction:
                  DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding:
                    const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white),
              ),
              onDismissed: (_) => cubit.remove(n.id),
              child: Container(
                margin:
                    const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: n.isRead
                      ? Colors.white
                      : AppColors.infoBg,
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.border),
                ),
                child: ListTile(
                  dense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2),
                  leading: Container(
                    padding:
                        const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: _bg(n.type),
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Icon(_icon(n.type),
                        color: _fg(n.type),
                        size: 20),
                  ),
                  title: Text(n.title,
                      style: TextStyle(
                          fontWeight: n.isRead
                              ? FontWeight.w600
                              : FontWeight.w700,
                          fontSize: 13)),
                  subtitle: Text(
                      '${n.body} • ${_timeAgo(n.createdAt)}',
                      style: AppStyles.caption),
                  trailing: n.isRead
                      ? null
                      : Container(
                          width: 10,
                          height: 10,
                          decoration:
                              const BoxDecoration(
                            color:
                                AppColors.primary,
                            shape:
                                BoxShape.circle,
                          ),
                        ),
                  onTap: () {
                    cubit.markRead(n.id);
                    Navigator.pop(context);
                    bukaHalamanSheet(
                        context, const SpkPage());
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _bg(NotifType t) => switch (t) {
        NotifType.spkBaru => AppColors.infoBg,
        NotifType.spkProses => AppColors.warningBg,
        NotifType.spkSelesai => AppColors.successBg,
        NotifType.info => AppColors.infoBg,
      };

  Color _fg(NotifType t) => switch (t) {
        NotifType.spkBaru => AppColors.info,
        NotifType.spkProses => AppColors.warning,
        NotifType.spkSelesai => AppColors.success,
        NotifType.info => AppColors.info,
      };

  IconData _icon(NotifType t) => switch (t) {
        NotifType.spkBaru => Icons.assignment_add,
        NotifType.spkProses =>
          Icons.autorenew_rounded,
        NotifType.spkSelesai =>
          Icons.check_circle_rounded,
        NotifType.info => Icons.info_rounded,
      };

  String _timeAgo(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'baru saja';
    if (d.inMinutes < 60) return '${d.inMinutes} mnt lalu';
    if (d.inHours < 24) return '${d.inHours} jam lalu';
    return '${d.inDays} hari lalu';
  }
}
