import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  // Save user during registration
  static Future<void> saveUser(
      String email,
      String password,
      String firstName,
      String lastName,
      String phone,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('phone', phone);
  }

  // Update password only, without touching other fields
  static Future<void> updatePassword(String email, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');

    if (savedEmail == email) {
      await prefs.setString('password', newPassword);
    }
  }

  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    return email == savedEmail && password == savedPassword;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }
}