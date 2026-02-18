import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _keyName = 'user_name';
  static const String _keyEmail = 'user_email';
  static const String _keyPassword = 'user_password';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // ✅ Simpan data user saat register
  static Future<bool> saveUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyName, name);
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyPassword, password);
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Ambil data user
  static Future<Map<String, dynamic>?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_keyName);
      final email = prefs.getString(_keyEmail);
      final password = prefs.getString(_keyPassword);

      if (name != null && email != null && password != null) {
        return {
          'name': name,
          'email': email,
          'password': password,
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ✅ Cek apakah user sudah login
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      return false;
    }
  }

  // ✅ Logout (hapus data)
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyName);
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyPassword);
      await prefs.setBool(_keyIsLoggedIn, false);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Update data user
  static Future<bool> updateUser({
    String? name,
    String? email,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (name != null) await prefs.setString(_keyName, name);
      if (email != null) await prefs.setString(_keyEmail, email);
      return true;
    } catch (e) {
      return false;
    }
  }
}
