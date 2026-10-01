import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
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
        final titles = {
          TeknisiMenu.beranda: 'SijaLink Teknisi',
          TeknisiMenu.customer: 'Customer',
          TeknisiMenu.genieAcs: 'GenieACS',
          TeknisiMenu.profil: 'Profil',
        };
        return Scaffold(
          appBar: AppBar(
            title: Text(titles[state.activeMenu]!),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            centerTitle: false,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.notifications_outlined),
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
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.activeMenu.index,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textGrey,
            onTap: (i) => context.read<DashboardBloc>().add(
                MenuChanged(TeknisiMenu.values[i])),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Beranda'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people_rounded),
                  label: 'Customer'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.cloud_rounded),
                  label: 'GenieACS'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Profil'),
            ],
          ),
        );
      },
    );
  }
}
