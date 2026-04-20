import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService {
  static const String _userKey = 'fixmate_user';
  static const String _tokenKey = 'fixmate_token';

  static User? _currentUser;

  static Future<User?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        _currentUser = User.fromJson(
          json.decode(userJson) as Map<String, dynamic>,
        );
        return _currentUser;
      } catch (_) {}
    }
    return null;
  }

  static Future<String?> getToken() async {
    final user = await getCurrentUser();
    return user?.token;
  }

  static Future<void> saveUser(User user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    if (user.token != null) {
      await prefs.setString(_tokenKey, user.token!);
    }
  }

  static Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    return await getCurrentUser() != null;
  }
}
