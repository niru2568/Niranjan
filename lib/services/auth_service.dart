import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _i = AuthService._();
  factory AuthService() => _i;
  AuthService._();

  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    final p = await SharedPreferences.getInstance();
    await p.setString('auth_token', token);
  }

  Future<String?> getToken() => _storage.read(key: 'auth_token');

  Future<void> saveUser(Map<String, dynamic> user) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('user_name', user['name'] ?? '');
    await p.setString('user_email', user['email'] ?? '');
    await p.setString('user_phone', user['phone'] ?? '');
    await p.setString('user_role', user['role'] ?? 'customer');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String> getUserRole() async {
    final p = await SharedPreferences.getInstance();
    return p.getString('user_role') ?? 'customer';
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    final p = await SharedPreferences.getInstance();
    await p.clear();
  }
}
