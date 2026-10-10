import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/profile_avatar.dart';
import '../bloc/profile_cubit.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 66),
          const PageHeader(title: 'Profil'),
          const SizedBox(height: 50),
          // Satu panel + foto profil timbul setengah
          // di luar panel.
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                          Color(0xFF2AA5CD),
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: BlocBuilder<ProfileCubit,
                          ProfileState>(
                        builder: (context, p) => Column(
                          children: [
                            // Ruang untuk separuh avatar.
                            SizedBox(
                                height:
                                    context.rs(68)),
                            Text(p.nama,
                                style: AppStyles.h2),
                            const SizedBox(height: 4),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.infoBg,
                                borderRadius:
                                    BorderRadius.circular(
                                        100),
                              ),
                              child: Text(p.role,
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w700,
                                      fontSize: 12,
                                      color: AppColors
                                          .primary)),
                            ),
                            const SizedBox(height: 20),
                            _row(
                                Icons.location_on_outlined,
                                'Alamat',
                                p.alamat),
                            _row(Icons.phone_outlined,
                                'Telepon', p.telp),
                            _row(Icons.dns_outlined,
                                'Mikrotik', p.mikrotik),
                            _row(Icons.email_outlined,
                                'Email', p.email),
                            const SizedBox(height: 12),
                            FractionallySizedBox(
                              widthFactor: 0.5,
                              child: ElevatedButton.icon(
                                style: ElevatedButton
                                    .styleFrom(
                                        backgroundColor:
                                            AppColors
                                                .danger,
                                        foregroundColor:
                                            Colors.white,
                                        minimumSize:
                                            const Size(
                                                0, 52),
                                        shape:
                                            const StadiumBorder()),
                                onPressed: () {},
                                icon: const Icon(
                                    Icons.logout),
                                label: const Text(
                                    'Keluar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Tombol edit di kanan atas panel.
                Positioned(
                  top: 12,
                  right: 12,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(100),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const EditProfilePage())),
                    child: Container(
                      padding:
                          const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 20),
                    ),
                  ),
                ),
                // Avatar timbul: setengah di luar panel.
                Positioned(
                  top: -context.rs(60),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: BlocBuilder<ProfileCubit,
                        ProfileState>(
                      builder: (context, p) =>
                          Container(
                        padding:
                            const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white,
                              width: 2),
                        ),
                        child: ProfileAvatar(
                            profile: p,
                            radius:
                                context.rs(60)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Label di luar kotak; kotak biru berisi nilai putih.
  static Widget _row(
      IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius:
                  BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon,
                    color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(value,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
