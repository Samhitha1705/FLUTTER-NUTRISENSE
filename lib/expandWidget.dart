import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

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
  String gender = "Other";
  DateTime? dob;

  bool vegMode = false;
  bool personalizedRatings = true;
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
      phone = prefs.getString("phone") ?? "";
      imagePath = prefs.getString("imagePath");
      gender = prefs.getString("gender") ?? "Other";

      String? dobStr = prefs.getString("dob");
      if (dobStr != null) dob = DateTime.tryParse(dobStr);
    });
  }

  Future pickImage() async {
    final prefs = await SharedPreferences.getInstance();
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() => imagePath = picked.path);
                  await prefs.setString("imagePath", picked.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await ImagePicker().pickImage(source: ImageSource.camera);
                if (picked != null) {
                  setState(() => imagePath = picked.path);
                  await prefs.setString("imagePath", picked.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 👤 PROFILE IMAGE
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: imagePath != null ? FileImage(File(imagePath!)) : null,
                child: imagePath == null ? const Icon(Icons.person, size: 50) : null,
              ),
            ),
            const SizedBox(height: 10),

            /// 👤 NAME
            Text(
              name.isEmpty ? "No Name" : name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            /// 📧 EMAIL
            Text(
              email.isEmpty ? "No Email" : email,
              style: const TextStyle(color: Colors.grey),
            ),

            /// ⚧ GENDER
            Text("Gender: $gender", style: const TextStyle(color: Colors.grey)),
            /// 🎂 DOB
            Text(
              dob != null ? "DOB: ${dob!.day}/${dob!.month}/${dob!.year}" : "DOB: Not set",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 10),

            /// ✏ EDIT PROFILE
            TextButton(
              onPressed: () async {
                bool? updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
                if (updated == true) loadProfile();
              },
              child: const Text("Edit Profile"),
            ),

            const Divider(height: 30),

            /// 🔹 PREFERENCES
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Preferences",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SwitchListTile(
              title: const Text("Veg Mode"),
              value: vegMode,
              onChanged: (val) {
                setState(() => vegMode = val);
              },
            ),
            SwitchListTile(
              title: const Text("Show Personalized Ratings"),
              value: personalizedRatings,
              onChanged: (val) {
                setState(() => personalizedRatings = val);
              },
            ),
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: darkMode,
              onChanged: (val) {
                setState(() => darkMode = val);
              },
            ),

            const Divider(height: 30),

            /// 🔹 FOOD DELIVERY SECTION
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Food Delivery",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text("Your Orders"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyOrdersPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text("Address Book"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressBookPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review_outlined),
              title: const Text("My Reviews"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReviewsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
