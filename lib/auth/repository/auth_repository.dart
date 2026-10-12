import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth_user.dart';

/// Auth dummy role teknisi. Nanti ganti isi login() pakai API/database.
class AuthRepository {
  static const _key = 'sijalink_auth_user';

  // Dummy: email + password + role teknisi.
  static const _dummyEmail = 'teknisi@sijalink.id';
  static const _dummyPassword = 'teknisi123';
  static const _dummyNama = 'Dika Pratama';
  static const _dummyRole = 'teknisi';

  /// Return user bila email+password cocok dummy, null bila salah.
  Future<AuthUser?> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final e = email.trim().toLowerCase();
    if (e == _dummyEmail && password == _dummyPassword) {
      const user = AuthUser(
        nama: _dummyNama,
        email: _dummyEmail,
        role: _dummyRole,
      );
      await simpan(user);
      return user;
    }
    return null;
  }

  Future<AuthUser?> ambilTersimpan() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return AuthUser.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> simpan(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
