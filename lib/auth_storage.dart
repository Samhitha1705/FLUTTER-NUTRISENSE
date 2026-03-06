import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String baseUrl = "http://192.168.100.162:8080/api/v1/customers";

  // Login API
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["accessToken"] ?? "");
        print("token stored successfully");
        await prefs.setBool("isLoggedIn", true);

        // Save user data if available
        if (data.containsKey('user')) {
          await saveUser(data['user']);
          print("user saved");
        }

        return true;
      } else {
        final body = jsonDecode(response.body);
        print(body["message"]);
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  // Set login status
  static Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", value);
  }

  // ✅ Save user data (single Map argument)
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (userData.containsKey('email')) {
      await prefs.setString('userEmail', userData['email']);
    }
    if (userData.containsKey('password')) {
      await prefs.setString('userPassword', userData['password']);
    }
    if (userData.containsKey('firstName')) {
      await prefs.setString('firstName', userData['firstName']);
    }
    if (userData.containsKey('lastName')) {
      await prefs.setString('lastName', userData['lastName']);
    }
    if (userData.containsKey('phone')) {
      await prefs.setString('phone', userData['phone']);
    }
  }
}