import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String? imagePath; // Local path or backend URL

  bool vegMode = false;
  bool personalizedRatings = true;
  bool darkMode = false;

  final String baseUrl = 'http://192.168.100.162:8080'; // Replace with your backend URL

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  /// Load profile from backend or cache
  Future loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/api/v1/customers/profile'),
          headers: { 'Authorization': 'Bearer $token' },
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            name = data['firstName'] ?? '';
            email = data['email'] ?? '';
            phone = data['phone'] ?? '';
            imagePath = data['imageUrl']; // Backend URL
          });

          // Cache locally
          await prefs.setString('name', name);
          await prefs.setString('email', email);
          await prefs.setString('phone', phone);
          if (imagePath != null) await prefs.setString('imagePath', imagePath!);
        }
      } catch (e) {
        // Fallback to local cache if backend fails
        setState(() {
          name = prefs.getString('name') ?? '';
          email = prefs.getString('email') ?? '';
          phone = prefs.getString('phone') ?? '';
          imagePath = prefs.getString('imagePath');
        });
      }
    }
  }

  /// Pick image and upload to backend
  Future pickImage() async {
    final prefs = await SharedPreferences.getInstance();
    final picker = ImagePicker();

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
                final picked = await picker.pickImage(source: ImageSource.gallery);
                if (picked != null) await uploadImage(File(picked.path));
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await picker.pickImage(source: ImageSource.camera);
                if (picked != null) await uploadImage(File(picked.path));
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Upload image to backend
  Future uploadImage(File file) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/v1/customers/profile/image'));
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          imagePath = data['imageUrl'];
        });
        await prefs.setString('imagePath', imagePath!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image upload failed')));
      }
    }
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
                backgroundImage: imagePath != null
                    ? (kIsWeb ? NetworkImage(imagePath!) : FileImage(File(imagePath!)) as ImageProvider)
                    : null,
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
              onChanged: (val) => setState(() => vegMode = val),
            ),

            SwitchListTile(
              title: const Text("Show Personalized Ratings"),
              value: personalizedRatings,
              onChanged: (val) => setState(() => personalizedRatings = val),
            ),

            SwitchListTile(
              title: const Text("Dark Mode"),
              value: darkMode,
              onChanged: (val) => setState(() => darkMode = val),
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
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyOrdersPage())),
            ),

            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text("Address Book"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressBookPage())),
            ),

            ListTile(
              leading: const Icon(Icons.rate_review_outlined),
              title: const Text("My Reviews"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewsPage())),
            ),
          ],
        ),
      ),
    );
  }
}