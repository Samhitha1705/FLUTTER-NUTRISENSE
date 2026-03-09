// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthStorage {
//   static const String baseUrl = "http://192.168.100.162:8080/api/v1/customers";
//
//   // Login API
//   static Future<bool> login(String email, String password) async {
//     final url = Uri.parse("$baseUrl/login");
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": email, "password": password}),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString("token", data["token"] ?? "");
//         await prefs.setBool("isLoggedIn", true);
//
//         // Save user data if available
//         if (data.containsKey('user')) {
//           await saveUser(data['user']);
//         }
//
//         return true;
//       } else {
//         final body = jsonDecode(response.body);
//         print(body["message"]);
//         return false;
//       }
//     } catch (e) {
//       print("Error: $e");
//       return false;
//     }
//   }
//
//   // Set login status
//   static Future<void> setLoggedIn(bool value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool("isLoggedIn", value);
//   }
//
//   // ✅ Save user data (single Map argument)
//   static Future<void> saveUser(Map<String, dynamic> userData) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     if (userData.containsKey('email')) {
//       await prefs.setString('userEmail', userData['email']);
//     }
//     if (userData.containsKey('password')) {
//       await prefs.setString('userPassword', userData['password']);
//     }
//     if (userData.containsKey('firstName')) {
//       await prefs.setString('firstName', userData['firstName']);
//     }
//     if (userData.containsKey('lastName')) {
//       await prefs.setString('lastName', userData['lastName']);
//     }
//     if (userData.containsKey('phone')) {
//       await prefs.setString('phone', userData['phone']);
//     }
//   }
// }

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
        // Save token
        await prefs.setString("token", data["accessToken"] ?? "");
        await prefs.setBool("isLoggedIn", true);

        // Save user data if available (nested userDto)
        if (data.containsKey('userDto')) {
          await saveUser(data['userDto']);
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

  // Save user data (single Map argument)
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

  // ===============================
  // NEW METHODS (DO NOT REMOVE)
  // ===============================

  // Get Token
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Get First Name
  static Future<String?> getFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("firstName");
  }

  // Get Last Name
  static Future<String?> getLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("lastName");
  }

  // Get Email
  static Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userEmail");
  }

  // Get Phone
  static Future<String?> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("phone");
  }

  // Check Login Status
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  // Logout
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
