import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/storage/asset_storage.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/widgets/profile_avatar.dart';
import '../bloc/profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nama;
  late final TextEditingController _role;
  late final TextEditingController _alamat;
  late final TextEditingController _telp;
  late final TextEditingController _mikrotik;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    final p = context.read<ProfileCubit>().state;
    _nama = TextEditingController(text: p.nama);
    _role = TextEditingController(text: p.role);
    _alamat = TextEditingController(text: p.alamat);
    _telp = TextEditingController(text: p.telp);
    _mikrotik = TextEditingController(text: p.mikrotik);
    _email = TextEditingController(text: p.email);
  }

  @override
  void dispose() {
    _nama.dispose();
    _role.dispose();
    _alamat.dispose();
    _telp.dispose();
    _mikrotik.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // Foto profil (bisa diganti).
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.all(
                                      3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors
                                        .primary,
                                    width: 2),
                              ),
                              child: BlocBuilder<
                                  ProfileCubit,
                                  ProfileState>(
                                builder: (context,
                                        p) =>
                                    ProfileAvatar(
                                        profile: p,
                                        radius: context
                                            .rs(44)),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius
                                        .circular(100),
                                onTap: () =>
                                    _pilihFoto(
                                        context),
                                child: Container(
                                  padding:
                                      const EdgeInsets
                                          .all(8),
                                  decoration:
                                      const BoxDecoration(
                                    color: AppColors
                                        .primary,
                                    shape:
                                        BoxShape.circle,
                                  ),
                                  child: const Icon(
                                      Icons
                                          .camera_alt_rounded,
                                      color: Colors.white,
                                      size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _field('Nama Lengkap', _nama,
                          Icons.person_outlined,
                          editable: false),
                      _field('Role', _role,
                          Icons.work_outlined,
                          editable: false),
                      _field('Alamat', _alamat,
                          Icons.location_on_outlined,
                          maxLines: 2),
                      _field('Telepon', _telp,
                          Icons.phone_outlined,
                          keyboard:
                              TextInputType.phone),
                      _field('Mikrotik', _mikrotik,
                          Icons.dns_outlined,
                          editable: false),
                      _field('Email', _email,
                          Icons.email_outlined,
                          keyboard: TextInputType
                              .emailAddress),
                      const SizedBox(height: 8),
                      Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.5,
                          child: ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<ProfileCubit>()
                                .update(
                                  alamat:
                                      _alamat.text,
                                  telp: _telp.text,
                                  email:
                                      _email.text,
                                );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(
                                    context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Profil berhasil disimpan'),
                                behavior:
                                    SnackBarBehavior
                                        .floating,
                                shape:
                                    StadiumBorder(),
                              ),
                            );
                          },
                          icon: const Icon(
                              Icons.save_outlined),
                          label:
                              const Text('Simpan'),
                        ),
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Sheet pilih sumber foto → simpan permanen ke folder
  /// upload, hapus file lama bila diganti/dihapus. Avatar di
  /// profil + dashboard ikut berubah via ProfileCubit.
  Future<void> _pilihFoto(BuildContext context) async {
    final punyaFoto =
        context.read<ProfileCubit>().state.fotoPath != null;
    final aksi = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.primary),
              title: const Text('Ambil Foto'),
              onTap: () =>
                  Navigator.pop(context, 'kamera'),
            ),
            ListTile(
              leading: const Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.primary),
              title: const Text('Pilih dari File'),
              onTap: () =>
                  Navigator.pop(context, 'galeri'),
            ),
            if (punyaFoto)
              ListTile(
                leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.danger),
                title: const Text('Hapus Foto Saat Ini',
                    style: TextStyle(
                        color: AppColors.danger)),
                onTap: () =>
                    Navigator.pop(context, 'hapus'),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (aksi == null || !context.mounted) return;
    final cubit = context.read<ProfileCubit>();
    final penyimpanan = AssetStorage();

    if (aksi == 'hapus') {
      await penyimpanan.hapusFile(cubit.state.fotoPath);
      if (!context.mounted) return;
      cubit.updateFoto(null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto profil dihapus'),
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder(),
        ),
      );
      return;
    }

    final file = await ImagePicker().pickImage(
      source: aksi == 'kamera'
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 512,
      imageQuality: 80,
    );
    if (file == null || !context.mounted) return;
    final permanen =
        await penyimpanan.simpanFotoProfil(file);
    final lama = cubit.state.fotoPath;
    cubit.updateFoto(permanen);
    // File lama sudah tak terpakai → hapus.
    await penyimpanan.hapusFile(
        lama == permanen ? null : lama);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto profil diperbarui'),
        behavior: SnackBarBehavior.floating,
        shape: StadiumBorder(),
      ),
    );
  }

  Widget _field(String label,
      TextEditingController controller, IconData icon,
      {int maxLines = 1,
      TextInputType keyboard = TextInputType.text,
      bool editable = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            enabled: editable,
            maxLines: maxLines,
            keyboardType: keyboard,
            decoration: InputDecoration(
              prefixIcon: Icon(icon,
                  color: editable
                      ? AppColors.primary
                      : AppColors.textGrey),
              filled: !editable,
              fillColor: editable
                  ? null
                  : AppColors.background,
            ),
          ),
        ],
      ),
    );
  }
}
