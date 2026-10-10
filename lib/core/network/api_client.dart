import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_config.dart';

/// Error standar untuk semua panggilan API.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'ApiException($statusCode): $message';
}

/// Client HTTP JSON terpusat. Dipakai oleh `Api*Repository`
/// saat backend sudah siap — repository dummy tidak memakainya.
class ApiClient {
  final http.Client _client;
  final String baseUrl;
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? ApiConfig.baseUrl;

  Map<String, String> get _headers => const {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      };

  Future<dynamic> get(String path,
      {Map<String, String>? query}) async {
    final uri =
        Uri.parse('$baseUrl$path').replace(queryParameters: query);
    late http.Response res;
    try {
      res = await _client
          .get(uri, headers: _headers)
          .timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const ApiException('Koneksi timeout');
    } on SocketException {
      throw const ApiException('Tidak ada koneksi');
    }
    return _decode(res);
  }

  Future<dynamic> post(
      String path, Map<String, dynamic> body) async {
    return _send('POST', path, body);
  }

  Future<dynamic> put(
      String path, Map<String, dynamic> body) async {
    return _send('PUT', path, body);
  }

  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    late http.Response res;
    try {
      res = await _client
          .delete(uri, headers: _headers)
          .timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const ApiException('Koneksi timeout');
    } on SocketException {
      throw const ApiException('Tidak ada koneksi');
    }
    return _decode(res);
  }

  Future<dynamic> _send(String method, String path,
      Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final fn = method == 'POST'
        ? _client.post(uri,
            headers: _headers, body: jsonEncode(body))
        : _client.put(uri,
            headers: _headers, body: jsonEncode(body));
    late http.Response res;
    try {
      res = await fn.timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const ApiException('Koneksi timeout');
    } on SocketException {
      throw const ApiException('Tidak ada koneksi');
    }
    return _decode(res);
  }

  dynamic _decode(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ApiException(
          'Server error (${res.statusCode})',
          res.statusCode);
    }
    if (res.body.isEmpty) return null;
    return jsonDecode(res.body);
  }

  /// Upload satu file (foto profil / foto absen) via multipart.
  /// Mengembalikan decoded JSON (biasanya berisi URL file).
  Future<dynamic> upload(String path, String filePath,
      {String field = 'file',
      Map<String, String>? fields}) async {
    final uri = Uri.parse('$baseUrl$path');
    final req = http.MultipartRequest('POST', uri)
      ..fields.addAll(fields ?? {})
      ..files.add(await http.MultipartFile.fromPath(
          field, filePath));
    late http.StreamedResponse streamed;
    try {
      streamed =
          await req.send().timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const ApiException('Koneksi timeout');
    } on SocketException {
      throw const ApiException('Tidak ada koneksi');
    }
    final res = await http.Response.fromStream(streamed);
    return _decode(res);
  }

  void dispose() => _client.close();
}
