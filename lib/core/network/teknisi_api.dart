import 'api_client.dart';
import 'api_config.dart';

/// HTTP method yang dipakai satu endpoint.
enum ApiMethod { get, post, put, delete }

/// Satu endpoint backend: method + path.
///
/// Path boleh mengandung placeholder `{nama}` yang diisi lewat
/// [panggil] parameter `params`. Contoh:
/// ```dart
/// TeknisiApi.spkUbahStatus.isi({'no': 'SPK-1024'})
/// // → /teknisi/spk/SPK-1024/status
/// ```
class ApiEndpoint {
  final ApiMethod method;
  final String path;
  const ApiEndpoint(this.method, this.path);

  String isi(Map<String, String> params) {
    var hasil = path;
    params.forEach((kunci, nilai) {
      hasil = hasil.replaceAll('{$kunci}', nilai);
    });
    return hasil;
  }
}

/// SATU FILE pusat koneksi API role Teknisi.
///
/// Cara pakai:
/// 1. Masukkan link API di [baseUrl] (atau tanpa edit kode:
///    `flutter run --dart-define=API_BASE_URL=https://api.sijalink.id`).
/// 2. Ambil endpoint + method yang dibutuhkan dari daftar bawah.
/// 3. Eksekusi via [panggil] (atau [upload] untuk file).
///
/// Contoh di repository:
/// ```dart
/// final json = await TeknisiApi.panggil(TeknisiApi.spkList);
/// return (json as List).map((e) => Spk.fromJson(e)).toList();
/// ```
abstract class TeknisiApi {
  // ── 1. LINK API ──────────────────────────────────────────
  static String get baseUrl => ApiConfig.baseUrl;

  static final ApiClient _client =
      ApiClient(baseUrl: ApiConfig.baseUrl);

  // ── 2. ENDPOINT + METHOD ─────────────────────────────────
  // SPK
  static const spkList =
      ApiEndpoint(ApiMethod.get, '/teknisi/spk');
  static const spkDetail =
      ApiEndpoint(ApiMethod.get, '/teknisi/spk/{no}');
  static const spkUbahStatus =
      ApiEndpoint(ApiMethod.put, '/teknisi/spk/{no}/status');

  // Tiket
  static const tiketList =
      ApiEndpoint(ApiMethod.get, '/teknisi/tiket');
  static const tiketDetail =
      ApiEndpoint(ApiMethod.get, '/teknisi/tiket/{no}');
  static const tiketUbahStatus =
      ApiEndpoint(ApiMethod.put, '/teknisi/tiket/{no}/status');

  // Customer
  static const customerList =
      ApiEndpoint(ApiMethod.get, '/teknisi/customer');
  static const customerDetail =
      ApiEndpoint(ApiMethod.get, '/teknisi/customer/{id}');

  // Mikrotik
  static const mikrotikList =
      ApiEndpoint(ApiMethod.get, '/teknisi/mikrotik');

  // GenieACS
  static const acsDevices =
      ApiEndpoint(ApiMethod.get, '/teknisi/acs/devices');
  static const acsReboot = ApiEndpoint(
      ApiMethod.post, '/teknisi/acs/devices/{serial}/reboot');

  // Presensi
  static const presensiRiwayat = ApiEndpoint(
      ApiMethod.get, '/teknisi/presensi/riwayat');
  static const presensiCheckIn = ApiEndpoint(
      ApiMethod.post, '/teknisi/presensi/check-in');
  static const presensiCheckOut = ApiEndpoint(
      ApiMethod.post, '/teknisi/presensi/check-out');
  static const presensiIzin = ApiEndpoint(
      ApiMethod.post, '/teknisi/presensi/izin');

  // Profil
  static const profil =
      ApiEndpoint(ApiMethod.get, '/teknisi/profil');
  static const profilUbah =
      ApiEndpoint(ApiMethod.put, '/teknisi/profil');

  // Upload file (foto profil / foto absen)
  static const upload =
      ApiEndpoint(ApiMethod.post, '/teknisi/upload');

  // Notifikasi
  static const notifikasiList = ApiEndpoint(
      ApiMethod.get, '/teknisi/notifikasi');
  static const notifikasiBacaSemua = ApiEndpoint(
      ApiMethod.put, '/teknisi/notifikasi/baca-semua');
  static const notifikasiBaca = ApiEndpoint(
      ApiMethod.put, '/teknisi/notifikasi/{id}/baca');

  // ── 3. EKSEKUTOR ─────────────────────────────────────────
  static Future<dynamic> panggil(
    ApiEndpoint endpoint, {
    Map<String, String> params = const {},
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) {
    final path = endpoint.isi(params);
    switch (endpoint.method) {
      case ApiMethod.get:
        return _client.get(path, query: query);
      case ApiMethod.post:
        return _client.post(path, body ?? {});
      case ApiMethod.put:
        return _client.put(path, body ?? {});
      case ApiMethod.delete:
        return _client.delete(path);
    }
  }

  /// Upload file ke endpoint [upload]. Mengembalikan URL file
  /// dari server (sesuaikan key `url` dengan respons backend).
  static Future<String?> uploadFile(String filePath,
      {String field = 'file'}) async {
    final json = await _client.upload(
        upload.path, filePath,
        field: field);
    if (json is Map) return json['url'] as String?;
    return null;
  }
}
