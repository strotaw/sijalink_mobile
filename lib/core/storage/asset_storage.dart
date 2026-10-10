import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Penyimpanan file upload lokal (calon database file).
///
/// - Foto profil: disalin ke folder `uploads/` agar permanen (file
///   mentah image_picker ada di cache yang bisa dibersihkan OS).
///   Saat diganti/dihapus → file lama ikut dihapus.
/// - Foto absen: disalin ke `uploads/` dan path-nya dicatat di
///   [PresensiRecord] sebagai riwayat foto (nanti dikirim ke
///   database backend bersama payload JSON).
class AssetStorage {
  static const _folder = 'uploads';

  Future<Directory> _dir() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory('${root.path}/$_folder');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String _nama(String prefix, String asal) {
    final ekstensi =
        asal.split('.').last.toLowerCase().contains(RegExp(r'^[a-z0-9]+$'))
            ? '.${asal.split('.').last.toLowerCase()}'
            : '.jpg';
    final waktu = DateTime.now()
        .millisecondsSinceEpoch
        .toString();
    return '$prefix-$waktu$ekstensi';
  }

  Future<String> _simpan(XFile file, String prefix) async {
    final dir = await _dir();
    final tujuan = File('${dir.path}/${_nama(prefix, file.path)}');
    await File(file.path).copy(tujuan.path);
    return tujuan.path;
  }

  /// Simpan foto profil baru → kembalikan path permanen.
  Future<String> simpanFotoProfil(XFile file) =>
      _simpan(file, 'profil');

  /// Simpan foto absen (check-in / check-out) → path permanen
  /// untuk riwayat.
  Future<String> simpanFotoAbsen(XFile file,
          {required String prefix}) =>
      _simpan(file, 'absen-$prefix');

  /// Hapus satu file bila masih ada. Aman dipanggil dengan
  /// path null / file yang sudah tidak ada.
  Future<void> hapusFile(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (_) {
      // File terkunci / sudah hilang: abaikan.
    }
  }

  /// Bersihkan file yatim: semua isi `uploads/` yang tidak ada
  /// di [dipakai] akan dihapus. Panggil misalnya saat aplikasi
  /// start dengan daftar path dari state (foto profil +
  /// seluruh foto riwayat absen).
  Future<void> bersihkanTakTerpakai(
      Set<String> dipakai) async {
    try {
      final dir = await _dir();
      await for (final entitas in dir.list()) {
        if (entitas is File &&
            !dipakai.contains(entitas.path)) {
          await entitas.delete();
        }
      }
    } catch (_) {}
  }
}
