import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:project/config/api_config.dart';

/// Thrown for any non-2xx response. [message] is the backend's error message
/// when available (see GlobalExceptionHandler on the backend), otherwise a
/// generic fallback.
class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class ApiClient {
  static Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  static Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  static Future<dynamic> get(String path, {String? token}) async {
    final response = await http.get(_uri(path), headers: _headers(token));
    return _handle(response);
  }

  static Future<dynamic> post(String path, {Map<String, dynamic>? body, String? token}) async {
    final response = await http.post(
      _uri(path),
      headers: _headers(token),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handle(response);
  }

  static Future<dynamic> put(String path, {Map<String, dynamic>? body, String? token}) async {
    final response = await http.put(
      _uri(path),
      headers: _headers(token),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handle(response);
  }

  static Future<dynamic> delete(String path, {String? token}) async {
    final response = await http.delete(_uri(path), headers: _headers(token));
    return _handle(response);
  }

  /// Uploads raw bytes as a multipart file (field name "file"). Works on
  /// mobile, desktop AND Flutter Web (unlike MultipartFile.fromPath, which
  /// needs a real filesystem path that doesn't exist on web).
  static Future<dynamic> uploadBytes(
    String path,
    List<int> bytes,
    String filename, {
    String? token,
  }) async {
    final request = http.MultipartRequest('POST', _uri(path));
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: filename,
      // Sans ceci, le package http envoie "application/octet-stream" par défaut,
      // que le backend rejette (il n'accepte que jpeg/png/webp).
      contentType: _mediaTypeForFilename(filename),
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handle(response);
  }

  static MediaType _mediaTypeForFilename(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.png')) return MediaType('image', 'png');
    if (lower.endsWith('.webp')) return MediaType('image', 'webp');
    return MediaType('image', 'jpeg'); // couvre .jpg/.jpeg et tout le reste par défaut
  }

  static dynamic _handle(http.Response response) {
    final status = response.statusCode;

    if (status == 204 || response.body.isEmpty) {
      if (status >= 200 && status < 300) return null;
      throw ApiException(status, 'Erreur serveur ($status)');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (status >= 200 && status < 300) {
      return decoded;
    }

    final message = (decoded is Map && decoded['message'] != null)
        ? decoded['message'] as String
        : 'Erreur serveur ($status)';
    throw ApiException(status, message);
  }
}