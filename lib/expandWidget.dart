import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_profile.dart';
import 'address_book_page.dart';
import 'my_orders.dart';

class ExpandWidget extends StatefulWidget {
  final String token;
  const ExpandWidget({super.key, required this.token});

  @override
  State<ExpandWidget> createState() => _ExpandWidgetState();
}

class _ExpandWidgetState extends State<ExpandWidget> {
  String name = "";
  String email = "";
  String phone = "";
  String goal = "";
  String healthHistory = "";
  String activityLevel = "";
  String createdAt = "";

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final response = await http.get(
      Uri.parse('http://192.168.100.162:8080/api/v1/customers'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        name = "${data['firstName']} ${data['lastName']}";
        email = data['email'] ?? "";
        phone = data['phone'] ?? "";
        goal = data['goal'] ?? "";
        healthHistory = data['healthHistory'] ?? "";
        activityLevel = data['activityLevel'] ?? "";
        createdAt = data['createdAt'] ?? "";
      });
    } else {
      print("Error fetching profile: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Email: $email"),
            Text("Phone: $phone"),
            Text("Goal: $goal"),
            Text("Health History: $healthHistory"),
            Text("Activity Level: $activityLevel"),
            Text("Account Created: $createdAt"),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                bool? updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProfilePage(token: widget.token)),
                );
                if (updated == true) fetchProfile();
              },
              child: const Text("Edit Profile"),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text("Your Orders"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyOrdersPage(token: widget.token))),
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text("Address Book"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddressBookPage(token: widget.token))),
            ),
          ],
        ),
      ),
    );
  }
}