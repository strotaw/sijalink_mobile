import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/auth_user.dart';
import '../repository/auth_repository.dart';

enum AuthStatus { awal, loading, masuk, keluar }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUser? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.awal,
    this.user,
    this.error,
  });

  bool get sudahMasuk => status == AuthStatus.masuk && user != null;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? error,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        error: error,
      );

  @override
  List<Object> get props => [status, user?.email ?? '', error ?? ''];
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;
  AuthCubit({AuthRepository? repo})
      : _repo = repo ?? AuthRepository(),
        super(const AuthState()) {
    cekSesi();
  }

  Future<void> cekSesi() async {
    final user = await _repo.ambilTersimpan();
    if (isClosed) return;
    if (user == null) {
      emit(const AuthState(status: AuthStatus.keluar));
    } else {
      emit(AuthState(status: AuthStatus.masuk, user: user));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    final user =
        await _repo.login(email: email, password: password);
    if (isClosed) return;
    if (user == null) {
      emit(state.copyWith(
        status: AuthStatus.keluar,
        error: 'Email atau password salah.',
      ));
    } else {
      emit(AuthState(status: AuthStatus.masuk, user: user));
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    if (isClosed) return;
    emit(const AuthState(status: AuthStatus.keluar));
  }
}
