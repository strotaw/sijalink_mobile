import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'teknisi/attendance/bloc/attendance_cubit.dart';
import 'auth/bloc/auth_cubit.dart';
import 'auth/view/auth_gate.dart';
import 'teknisi/customer/bloc/customer_cubit.dart';
import 'teknisi/dashboard/bloc/dashboard_bloc.dart';
import 'teknisi/genie_acs/bloc/genie_acs_cubit.dart';
import 'teknisi/mikrotik/bloc/mikrotik_cubit.dart';
import 'teknisi/notification/bloc/notification_cubit.dart';
import 'teknisi/profile/bloc/profile_cubit.dart';
import 'teknisi/spk/bloc/spk_cubit.dart';
import 'teknisi/ticket/bloc/ticket_cubit.dart';

void main() {
  runApp(const SijaLinkApp());
}

class SijaLinkApp extends StatelessWidget {
  const SijaLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => DashboardBloc()),
        BlocProvider(create: (_) => AttendanceCubit()),
        BlocProvider(create: (_) => SpkCubit()),
        BlocProvider(create: (_) => TicketCubit()),
        BlocProvider(create: (_) => MikrotikCubit()),
        BlocProvider(create: (_) => CustomerCubit()),
        BlocProvider(create: (_) => GenieAcsCubit()),
        BlocProvider(create: (_) => NotificationCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
      ],
      child: MaterialApp(
        title: 'SijaLink Teknisi',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const AuthGate(),
      ),
    );
  }
}
