import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../customer/view/customer_page.dart';
import '../../genie_acs/view/genie_acs_page.dart';
import '../../home/view/home_page.dart';
import '../../profile/view/profile_page.dart';
import '../../notification/bloc/notification_cubit.dart';
import '../../notification/view/notification_page.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

/// Shell Android teknisi dengan BottomNavigationBar.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final titles = {
          TeknisiMenu.customer: 'Customer',
          TeknisiMenu.genieAcs: 'GenieACS',
          TeknisiMenu.profil: 'Profil',
        };
        final isBeranda =
            state.activeMenu == TeknisiMenu.beranda;
        return Scaffold(
          // Beranda: tanpa AppBar + background biru sampai bawah —
          // header profil + lonceng sudah ada di dalam HomePage.
          backgroundColor: isBeranda
              ? AppColors.primaryDark
              : null,
          appBar: isBeranda
              ? null
              : AppBar(
                  title:
                      Text(titles[state.activeMenu]!),
                  shape:
                      const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 16),
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(
                                16),
                        onTap: () =>
                            showNotificationPopup(
                                context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: BlocBuilder<
                        NotificationCubit,
                        NotificationState>(
                      builder: (context, n) =>
                          Badge(
                        isLabelVisible:
                            n.unreadCount > 0,
                        label: Text(
                            '${n.unreadCount}'),
                        backgroundColor:
                            AppColors.danger,
                        child: const Icon(
                            Icons
                                .notifications_outlined,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: IndexedStack(
            index: state.activeMenu.index,
            children: const [
              HomePage(),
              CustomerPage(),
              GenieAcsPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    16, 12, 16, 12),
                child: Row(
                  children: [
                    _navItem(
                      context,
                      selected:
                          state.activeMenu ==
                              TeknisiMenu.beranda,
                      icon: Icons.home_rounded,
                      label: 'Beranda',
                      onTap: () => context
                          .read<DashboardBloc>()
                          .add(MenuChanged(
                              TeknisiMenu.beranda)),
                    ),
                    _navItem(
                      context,
                      selected:
                          state.activeMenu ==
                              TeknisiMenu.customer,
                      icon: Icons.people_rounded,
                      label: 'Customer',
                      onTap: () => context
                          .read<DashboardBloc>()
                          .add(MenuChanged(
                              TeknisiMenu.customer)),
                    ),
                    _navItem(
                      context,
                      selected:
                          state.activeMenu ==
                              TeknisiMenu.genieAcs,
                      icon: Icons.cloud_rounded,
                      label: 'GenieACS',
                      onTap: () => context
                          .read<DashboardBloc>()
                          .add(MenuChanged(
                              TeknisiMenu.genieAcs)),
                    ),
                    _navItem(
                      context,
                      selected:
                          state.activeMenu ==
                              TeknisiMenu.profil,
                      icon: Icons.person_rounded,
                      label: 'Profil',
                      onTap: () => context
                          .read<DashboardBloc>()
                          .add(MenuChanged(
                              TeknisiMenu.profil)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Item nav custom: belum aktif = ikon saja (lingkaran putih,
/// ikon biru); aktif = pill biru tua (ikon putih + label di kanan).
Widget _navItem(
  BuildContext context, {
  required bool selected,
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Expanded(
    flex: selected ? 3 : 2,
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        height: 52,
        margin:
            const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration:
                  const Duration(milliseconds: 250),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.transparent
                    : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: selected
                      ? Colors.white
                      : AppColors.primary,
                  size: 24),
            ),
            if (selected) ...[
              const SizedBox(width: 2),
              Flexible(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
            ],
          ],
        ),
      ),
    ),
  );
}
