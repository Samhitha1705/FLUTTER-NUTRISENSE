import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'edit_profile.dart';
import 'my_orders.dart';
import 'address_book_page.dart';
import 'reviews_page.dart';

class ExpandWidget extends StatefulWidget {
  const ExpandWidget({super.key});

  @override
  State<ExpandWidget> createState() => _ExpandWidgetState();
}

class _ExpandWidgetState extends State<ExpandWidget> {

  String name = "";
  String email = "";
  String phone = "";
  String? imagePath;

  String goal = "";
  String healthHistory = "";
  double height = 0;
  double weight = 0;
  String activityLevel = "";

  final String baseUrl = "http://192.168.100.162:8080";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
      phone = prefs.getString("phone") ?? "";
      imagePath = prefs.getString("imagePath");

      goal = prefs.getString("goal") ?? "";
      healthHistory = prefs.getString("healthHistory") ?? "";
      height = prefs.getDouble("height") ?? 0;
      weight = prefs.getDouble("weight") ?? 0;
      activityLevel = prefs.getString("activityLevel") ?? "";
    });

    String? token = prefs.getString('token');
    if (token == null) return;

    try {

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/customers/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {

        final data = json.decode(response.body);
        final customer = data['customerResponseDto'] ?? data;

        String fullName =
        "${customer['firstName'] ?? ''} ${customer['lastName'] ?? ''}".trim();

        setState(() {
          name = fullName;
          email = customer['email'] ?? "";
          phone = customer['phone'] ?? "";
        });

        await prefs.setString('name', fullName);
        await prefs.setString('email', email);
        await prefs.setString('phone', phone);
      }

    } catch (e) {
      print(e);
    }
  }

  Future<void> pickImage() async {

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {

      final prefs = await SharedPreferences.getInstance();

      setState(() {
        imagePath = picked.path;
      });

      await prefs.setString("imagePath", picked.path);
    }
  }

  Widget profileImage() {

    if (imagePath != null && File(imagePath!).existsSync()) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(File(imagePath!)),
      );
    }

    return const CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage("assets/images/profile.png"),
    );
  }

  Widget profileStat(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(color: Colors.grey))
        ],
      ),
    );
  }

  Widget menuTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      body: SingleChildScrollView(

        child: Column(

          children: [

            const SizedBox(height: 20),

            /// PROFILE HEADER
            GestureDetector(
              onTap: pickImage,
              child: profileImage(),
            ),

            const SizedBox(height: 10),

            Text(
              name.isEmpty ? "User" : name,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(
              email,
              style: const TextStyle(color: Colors.grey),
            ),

            if (phone.isNotEmpty)
              Text(
                phone,
                style: const TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 25),

            /// HEALTH CARD
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(

                  children: [

                    Row(
                      children: [
                        profileStat("Height", "$height cm", Icons.height),
                        profileStat("Weight", "$weight kg", Icons.monitor_weight),
                        profileStat("Activity", activityLevel, Icons.directions_run),
                      ],
                    ),

                    const SizedBox(height: 15),

                    if (goal.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.flag, color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(child: Text("Goal: $goal")),
                        ],
                      ),

                    const SizedBox(height: 10),

                    if (healthHistory.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.health_and_safety,
                              color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(child: Text(healthHistory)),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// MENU OPTIONS
            menuTile(Icons.edit, "Edit Profile", () async {

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );

              if (result == true) {
                loadProfile();
              }
            }),

            menuTile(Icons.shopping_bag, "My Orders", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyOrdersPage(),
                ),
              );
            }),

            menuTile(Icons.location_on, "Address Book", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddressBookPage(),
                ),
              );
            }),

            menuTile(Icons.reviews, "Reviews", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewsPage(),
                ),
              );
            }),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}