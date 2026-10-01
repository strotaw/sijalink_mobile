import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/attendance/bloc/attendance_cubit.dart';
import 'features/customer/bloc/customer_cubit.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/dashboard/view/dashboard_page.dart';
import 'features/genie_acs/bloc/genie_acs_cubit.dart';
import 'features/mikrotik/bloc/mikrotik_cubit.dart';
import 'features/spk/bloc/spk_cubit.dart';

void main() {
  runApp(const SijaLinkApp());
}

class SijaLinkApp extends StatelessWidget {
  const SijaLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DashboardBloc()),
        BlocProvider(create: (_) => AttendanceCubit()),
        BlocProvider(create: (_) => SpkCubit()),
        BlocProvider(create: (_) => MikrotikCubit()),
        BlocProvider(create: (_) => CustomerCubit()),
        BlocProvider(create: (_) => GenieAcsCubit()),
      ],
      child: MaterialApp(
        title: 'SijaLink Teknisi',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const DashboardPage(),
      ),
    );
  }
}
