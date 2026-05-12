import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();
  static const _keyToken = 'auth_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> readToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
}

class UserStorage {
  final _storage = const FlutterSecureStorage();
  static const _keyUser = 'auth_user';

  Future<void> saveUser(User user) async {
    await _storage.write(key: _keyUser, value: jsonEncode(user.toJson()));
  }

  Future<User?> readUser() async {
    final data = await _storage.read(key: _keyUser);
    if (data != null) {
      return User.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _keyUser);
  }
}
