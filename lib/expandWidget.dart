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

  final String baseUrl = "http://10.0.2.2:8080";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  /// LOAD PROFILE
  Future loadProfile() async {

    final prefs = await SharedPreferences.getInstance();

    /// 1️⃣ LOAD LOCAL DATA FIRST
    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
      phone = prefs.getString("phone") ?? "";
      imagePath = prefs.getString("imagePath");
    });

    String? token = prefs.getString('token');

    /// 2️⃣ FETCH LATEST PROFILE FROM BACKEND
    try {

      if (token != null) {

        final response = await http.get(
          Uri.parse('$baseUrl/api/v1/customers/profile'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
        );

        if (response.statusCode == 200) {

          final data = json.decode(response.body);

          String firstName = data['firstName'] ?? '';
          String lastName = data['lastName'] ?? '';
          String emailRes = data['email'] ?? '';
          String phoneRes = data['phone'] ?? '';

          setState(() {
            name = "$firstName $lastName";
            email = emailRes;
            phone = phoneRes;
          });

          /// SAVE UPDATED DATA
          await prefs.setString('name', name);
          await prefs.setString('email', emailRes);
          await prefs.setString('phone', phoneRes);
        }
      }

    } catch (e) {
      print("PROFILE ERROR: $e");
    }
  }

  /// PICK IMAGE
  Future pickImage() async {

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {

      final prefs = await SharedPreferences.getInstance();

      setState(() {
        imagePath = pickedFile.path;
      });

      await prefs.setString("imagePath", pickedFile.path);
    }
  }

  /// PROFILE IMAGE
  Widget profileImage() {

    if (imagePath != null && File(imagePath!).existsSync()) {
      return CircleAvatar(
        radius: 45,
        backgroundImage: FileImage(File(imagePath!)),
      );
    }

    return const CircleAvatar(
      radius: 45,
      backgroundImage: AssetImage("assets/images/profile.png"),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// PROFILE IMAGE
            GestureDetector(
              onTap: pickImage,
              child: profileImage(),
            ),

            const SizedBox(height: 10),

            const Text(
              "Tap to change profile picture",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// NAME
            Text(
              name.isEmpty ? "User" : name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            /// EMAIL
            Text(
              email.isEmpty ? "No Email" : email,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 5),

            /// PHONE
            Text(
              phone.isEmpty ? "" : phone,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// MENU LIST
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profile"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("My Orders"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyOrdersPage(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Address Book"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressBookPage(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.reviews),
              title: const Text("Reviews"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReviewsPage(),
                  ),
                );
              },
            ),

            const Divider(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}