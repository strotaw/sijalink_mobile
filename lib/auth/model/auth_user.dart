/// Akun login yang sedang aktif.
class AuthUser {
  final String nama;
  final String email;
  final String role;

  const AuthUser({
    required this.nama,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'email': email,
        'role': role,
      };

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        nama: json['nama'] as String? ?? '',
        email: json['email'] as String? ?? '',
        role: json['role'] as String? ?? '',
      );
}
