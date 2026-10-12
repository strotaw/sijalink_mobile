import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/auth_cubit.dart';

/// Halaman login teknisi: email + password saja.
/// Dummy: teknisi@sijalink.id / teknisi123 (role teknisi).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _tampilPassword = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _masuk() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().login(
          email: _email.text,
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Area atas 30%: judul nempel bawah.
              const Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Text(
                      'Selamat Datang!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // Panel putih 70% bawah, kiri atas round 75,
              // kanan atas lurus.
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: SingleChildScrollView(
                    child: BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state.error != null) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                        }
                      },
                      builder: (context, state) {
                        final sibuk =
                            state.status == AuthStatus.loading;
                        return Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            // Judul panel di kanan.
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Welcome Back',
                                style: AppStyles.h2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Pakai email dan password akun teknisi.',
                                textAlign: TextAlign.right,
                                style: AppStyles.body,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('Email',
                                style: AppStyles.h3),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _email,
                              keyboardType:
                                  TextInputType.emailAddress,
                              enabled: !sibuk,
                              decoration: const InputDecoration(
                                hintText: 'teknisi@sijalink.id',
                                prefixIcon:
                                    Icon(Icons.email_outlined),
                              ),
                              onSubmitted: (_) => _masuk(),
                            ),
                            const SizedBox(height: 16),
                            const Text('Password',
                                style: AppStyles.h3),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _password,
                              obscureText: !_tampilPassword,
                              enabled: !sibuk,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon: const Icon(
                                    Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() =>
                                      _tampilPassword =
                                          !_tampilPassword),
                                  icon: Icon(
                                    _tampilPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              onSubmitted: (_) => _masuk(),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: sibuk ? null : _masuk,
                              child: sibuk
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Masuk'),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.infoBg,
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Dummy:\nteknisi@sijalink.id / teknisi123',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
