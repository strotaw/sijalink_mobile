import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_cubit.dart';
import 'login_page.dart';
import '../../teknisi/dashboard/view/dashboard_page.dart';

/// Penjaga: belum login → LoginPage, sudah login → DashboardPage.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.masuk && state.user != null) {
          return const DashboardPage();
        }
        if (state.status == AuthStatus.awal ||
            state.status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const LoginPage();
      },
    );
  }
}
