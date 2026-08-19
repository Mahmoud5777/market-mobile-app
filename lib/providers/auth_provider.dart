import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project/models/app_user.dart';
import 'package:project/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _emailKey = 'auth_email';
  static const _fullNameKey = 'auth_full_name';
  static const _roleKey = 'auth_role';

  String? _token;
  AppUser? _user;
  bool _isLoading = true;

  String? get token => _token;
  AppUser? get user => _user;
  bool get isAuthenticated => _token != null && _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isLoading => _isLoading;

  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    final token = await _storage.read(key: _tokenKey);
    final email = await _storage.read(key: _emailKey);
    final fullName = await _storage.read(key: _fullNameKey);
    final role = await _storage.read(key: _roleKey);

    if (token != null && email != null) {
      _token = token;
      _user = AppUser(email: email, fullName: fullName ?? '', role: role ?? 'USER');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    final result = await AuthService.login(email: email, password: password);
    await _persistSession(result);
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await AuthService.register(fullName: fullName, email: email, password: password);
    await _persistSession(result);
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String currentPassword,
    String? newPassword,
  }) async {
    if (_token == null) return;
    final result = await AuthService.updateProfile(
      fullName: fullName,
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
      token: _token!,
    );
    await _persistSession(result);
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await _storage.deleteAll();
    notifyListeners();
  }

  Future<void> _persistSession(AuthResult result) async {
    _token = result.token;
    _user = result.user;

    await _storage.write(key: _tokenKey, value: result.token);
    await _storage.write(key: _emailKey, value: result.user.email);
    await _storage.write(key: _fullNameKey, value: result.user.fullName);
    await _storage.write(key: _roleKey, value: result.user.role);

    notifyListeners();
  }
}