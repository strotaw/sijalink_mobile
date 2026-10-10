import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/responsive.dart';
import '../../customer/view/customer_page.dart';
import '../../genie_acs/view/genie_acs_page.dart';
import '../../home/view/home_page.dart';
import '../../profile/view/profile_page.dart';
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
        return Scaffold(
          // Semua tab tanpa AppBar — header (nama halaman
          // + lonceng) ada di dalam tiap halaman.
          backgroundColor: AppColors.primaryDark,
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
            color: AppColors.primaryDark,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    context.rs(16),
                    context.rs(12),
                    context.rs(16),
                    context.rs(12)),
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
/// ikon biru, lebar tetap); aktif = pill biru memenuhi sisa
/// ruang (ikon putih + label full di kanan).
Widget _navItem(
  BuildContext context, {
  required bool selected,
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  final lingkaran = AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    width: context.rs(52),
    height: context.rs(52),
    decoration: BoxDecoration(
      color:
          selected ? Colors.transparent : Colors.white,
      shape: BoxShape.circle,
    ),
    child: Icon(icon,
        color: selected
            ? Colors.white
            : AppColors.primary,
        size: context.rs(35)),
  );

  final isi = selected
      ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            lingkaran,
            SizedBox(width: context.rs(2)),
            Flexible(
              child: Text(label,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: context.rs(13),
                      fontWeight: FontWeight.w700)),
            ),
            SizedBox(width: context.rs(12)),
          ],
        )
      : Center(child: lingkaran);

  final bungkus = AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
    height: context.rs(60),
    margin: EdgeInsets.symmetric(
        horizontal: context.rs(4)),
    decoration: BoxDecoration(
      color: selected
          ? AppColors.primary
          : Colors.transparent,
      borderRadius: BorderRadius.circular(100),
    ),
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: isi,
    ),
  );

  // Aktif memenuhi sisa ruang, lainnya minggir
  // selebar ikon agar label tampil penuh.
  if (selected) {
    return Expanded(child: bungkus);
  }
  return SizedBox(width: context.rs(64), child: bungkus);
}
