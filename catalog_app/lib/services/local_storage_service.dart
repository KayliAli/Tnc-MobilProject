import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _usersKey = 'local_users';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  LocalStorageService({
    Future<void> Function(String key, String value)? writeSecret,
    Future<String?> Function(String key)? readSecret,
  }) : _writeSecret = writeSecret ?? _defaultWriteSecret,
       _readSecret = readSecret ?? _defaultReadSecret;

  final Future<void> Function(String key, String value) _writeSecret;
  final Future<String?> Function(String key) _readSecret;

  static Future<void> _defaultWriteSecret(String key, String value) =>
      _secureStorage.write(key: key, value: value);

  static Future<String?> _defaultReadSecret(String key) =>
      _secureStorage.read(key: key);

  Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> clearData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  Future<void> saveStringList(String key, List<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, values);
  }

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final users = _readUsers(prefs.getString(_usersKey));
    final normalizedEmail = email.trim().toLowerCase();

    if (users.containsKey(normalizedEmail)) return false;

    await _writeSecret('user_password:$normalizedEmail', password);
    users[normalizedEmail] = {'name': name.trim()};
    await prefs.setString(_usersKey, jsonEncode(users));
    return true;
  }

  Future<bool> authenticateUser({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final normalizedEmail = email.trim().toLowerCase();
    final user = _readUsers(prefs.getString(_usersKey))[normalizedEmail];
    if (user is! Map) return false;
    return await _readSecret('user_password:$normalizedEmail') == password;
  }

  Future<bool> hasRegisteredUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final user = _readUsers(
      prefs.getString(_usersKey),
    )[email.trim().toLowerCase()];
    return user is Map;
  }

  Map<String, dynamic> _readUsers(String? encodedUsers) {
    if (encodedUsers == null) return {};
    try {
      final decoded = jsonDecode(encodedUsers);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      return {};
    }
    return {};
  }
}
