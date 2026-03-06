import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth_storage.dart';

class ProfileService {
  static const String baseUrl =
      "http://192.168.100.162:8080/api/v1/nutritionists/me";

  /// --------------------------
  /// GET PROFILE
  /// --------------------------
  static Future<Map<String, dynamic>?> getMyProfile() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      print("No token found for fetching profile");
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print("GET Profile Status: ${response.statusCode}");
      print("GET Profile Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Profile Fetch Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Profile Fetch Exception: $e");
      return null;
    }
  }

  /// --------------------------
  /// UPDATE PROFILE
  /// --------------------------
  static Future<bool> updateProfile({
    String? qualification,
    int? experience,
    String? profilePhoto,
    String? aadhaarRef,
  }) async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      print("No token found for updating profile");
      return false;
    }

    // Only include non-null fields in the body
    final Map<String, dynamic> body = {};
    if (qualification != null && qualification.isNotEmpty) {
      body['qualification'] = qualification;
    }
    if (experience != null) {
      body['experience'] = experience;
    }
    if (profilePhoto != null && profilePhoto.isNotEmpty) {
      body['profilePhoto'] = profilePhoto;
    }
    if (aadhaarRef != null && aadhaarRef.isNotEmpty) {
      body['aadhaarRef'] = aadhaarRef;
    }

    try {
      print("Token used for update: $token");
      print("Update Body: $body");

      final uri = Uri.parse(baseUrl).replace(queryParameters: body);

      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },

      );

      print("Update Status Code: ${response.statusCode}");
      print("Update Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("Profile Updated Successfully");
        return true;
      } else {
        print("Update Failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Update Exception: $e");
      return false;
    }
  }
}