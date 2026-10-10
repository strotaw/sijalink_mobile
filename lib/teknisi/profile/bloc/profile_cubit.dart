import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/profile_repository.dart';

class ProfileState extends Equatable {
  final String nama;
  final String role;
  final String alamat;
  final String telp;
  final String mikrotik;
  final String email;
  final String? fotoPath;

  const ProfileState({
    this.nama = 'Dika Pratama',
    this.role = 'Teknisi Lapangan',
    this.alamat = 'Jl. Merpati No. 12, Timur',
    this.telp = '0812-3456-7890',
    this.mikrotik = 'MT-Cabang Timur',
    this.email = 'dika@sijalink.id',
    this.fotoPath,
  });

  String get inisial => nama
      .split(' ')
      .where((w) => w.isNotEmpty)
      .take(2)
      .map((w) => w[0].toUpperCase())
      .join();

  factory ProfileState.fromJson(Map<String, dynamic> json) =>
      ProfileState(
        nama: json['nama'] as String? ?? '',
        role: json['role'] as String? ?? '',
        alamat: json['alamat'] as String? ?? '',
        telp: json['telp'] as String? ?? '',
        mikrotik: json['mikrotik'] as String? ?? '',
        email: json['email'] as String? ?? '',
        fotoPath: json['fotoPath'] as String?,
      );

  @override
  List<Object> get props =>
      [nama, role, alamat, telp, mikrotik, email, fotoPath ?? ''];
}

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  ProfileCubit({ProfileRepository? repository})
      : _repository = repository ?? DummyProfileRepository(),
        super(const ProfileState()) {
    muatUlang();
  }

  Future<void> muatUlang() async {
    try {
      final profil = await _repository.fetchProfile();
      if (isClosed) return;
      // Pertahankan foto lokal bila sudah dipilih.
      emit(ProfileState(
        nama: profil.nama,
        role: profil.role,
        alamat: profil.alamat,
        telp: profil.telp,
        mikrotik: profil.mikrotik,
        email: profil.email,
        fotoPath: state.fotoPath ?? profil.fotoPath,
      ));
    } catch (_) {}
  }

  void update({
    String? alamat,
    String? telp,
    String? email,
  }) {
    emit(ProfileState(
      nama: state.nama,
      role: state.role,
      alamat: alamat ?? state.alamat,
      telp: telp ?? state.telp,
      mikrotik: state.mikrotik,
      email: email ?? state.email,
      fotoPath: state.fotoPath,
    ));
  }

  void updateFoto(String? path) {
    emit(ProfileState(
      nama: state.nama,
      role: state.role,
      alamat: state.alamat,
      telp: state.telp,
      mikrotik: state.mikrotik,
      email: state.email,
      fotoPath: path,
    ));
  }
}
