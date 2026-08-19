import 'package:project/models/app_user.dart';
import 'package:project/services/api_client.dart';

class AuthResult {
  final String token;
  final AppUser user;
  const AuthResult({required this.token, required this.user});
}

class AuthService {
  static Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final json = await ApiClient.post('/api/auth/register', body: {
      'fullName': fullName,
      'email': email,
      'password': password,
    });
    return _fromJson(json);
  }

  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final json = await ApiClient.post('/api/auth/login', body: {
      'email': email,
      'password': password,
    });
    return _fromJson(json);
  }

  static Future<AuthResult> updateProfile({
    required String fullName,
    required String email,
    required String currentPassword,
    String? newPassword,
    required String token,
  }) async {
    final json = await ApiClient.put('/api/auth/me', body: {
      'fullName': fullName,
      'email': email,
      'currentPassword': currentPassword,
      if (newPassword != null && newPassword.isNotEmpty) 'newPassword': newPassword,
    }, token: token);
    return _fromJson(json);
  }

  static AuthResult _fromJson(Map<String, dynamic> json) {
    return AuthResult(
      token: json['token'] as String,
      user: AppUser.fromJson(json),
    );
  }
}