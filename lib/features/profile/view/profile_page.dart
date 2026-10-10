import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/page_header.dart';

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
      child: ListView(
        padding: const EdgeInsets.symmetric(
            vertical: 16),
        children: [
          const SizedBox(height: 50),
          const PageHeader(title: 'Profil'),
          const SizedBox(height: 50),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xFF2AA5CD),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(20),
            child: const Column(
              children: [
                CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    child: Text('TD',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700))),
                SizedBox(height: 12),
                Text('Teknisi Dika',
                    style: AppStyles.h2),
                Text('ID: TEK-007 • Area Timur',
                    style: AppStyles.caption),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xFF2AA5CD),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                ListTile(
                    leading: Icon(Icons.badge,
                        color: AppColors.primary),
                    title: Text('Nama Lengkap'),
                    subtitle: Text('Dika Pratama')),
                Divider(height: 1),
                ListTile(
                    leading: Icon(Icons.phone,
                        color: AppColors.primary),
                    title: Text('No. HP'),
                    subtitle:
                        Text('0812-3456-7890')),
                Divider(height: 1),
                ListTile(
                    leading: Icon(Icons.email,
                        color: AppColors.primary),
                    title: Text('Email'),
                    subtitle: Text(
                        'dika@sijalink.id')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                minimumSize:
                    const Size.fromHeight(52),
                shape: const StadiumBorder()),
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
