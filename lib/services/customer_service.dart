import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerService {

  static const String baseUrl = "http://192.168.100.162:8080/api/v1";

  //----------------------------------
  // GET TOKEN
  //----------------------------------

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  //----------------------------------
  // UPDATE CUSTOMER GOAL
  //----------------------------------

  static Future<bool> updateCustomerGoal({
    required String goal,
    required String healthHistory,
    required double height,
    required double weight,
    required String activityLevel,
  }) async {

    final token = await getToken();

    final url = Uri.parse("$baseUrl/customers/goal");

    final body = {
      "goal": goal,
      "healthHistory": healthHistory,
      "height": height,
      "weight": weight,
      "activityLevel": activityLevel
    };

    try {

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("PUT STATUS: ${response.statusCode}");
      print("PUT RESPONSE: ${response.body}");

      return response.statusCode == 200;

    } catch (e) {

      print("PUT ERROR: $e");
      return false;

    }
  }
}