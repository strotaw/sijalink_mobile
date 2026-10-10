import 'dart:io';

import 'package:flutter/material.dart';
import '../../teknisi/profile/bloc/profile_cubit.dart';
import '../theme/app_colors.dart';

/// Avatar teknisi bersama: menampilkan foto profil jika sudah
/// diupload, atau inisial nama. Dipakai di dashboard (beranda)
/// dan halaman profil — keduanya membaca ProfileCubit yang sama.
class ProfileAvatar extends StatelessWidget {
  final ProfileState profile;
  final double radius;
  const ProfileAvatar(
      {super.key, required this.profile, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    final foto = profile.fotoPath;
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      backgroundImage:
          foto != null ? FileImage(File(foto)) : null,
      child: foto != null
          ? null
          : Text(profile.inisial,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: radius * 0.75,
                  fontWeight: FontWeight.w700)),
    );
  }
}
