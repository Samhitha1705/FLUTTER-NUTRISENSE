import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final String token;
  const EditProfilePage({super.key, required this.token});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController healthHistoryController = TextEditingController();
  String activityLevel = "Low";

  final List<String> activityOptions = ["Low", "Medium", "High"];

  bool isLoading = false;

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
        firstNameController.text = data['firstName'] ?? "";
        lastNameController.text = data['lastName'] ?? "";
        phoneController.text = data['phone'] ?? "";
        goalController.text = data['goal'] ?? "";
        healthHistoryController.text = data['healthHistory'] ?? "";
        activityLevel = data['activityLevel'] ?? "Low";
      });
    } else {
      print("Error fetching profile: ${response.statusCode}");
    }
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final body = {
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "phone": phoneController.text.trim(),
      "goal": goalController.text.trim(),
      "healthHistory": healthHistoryController.text.trim(),
      "activityLevel": activityLevel,
    };

    final response = await http.put(
      Uri.parse('http://192.168.100.162:8080/api/v1/customers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}'
      },
      body: jsonEncode(body),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      Navigator.pop(context, true); // Return true to refresh profile
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: ${response.statusCode}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), backgroundColor: Colors.green),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: goalController,
                decoration: const InputDecoration(labelText: "Goal"),
              ),
              TextFormField(
                controller: healthHistoryController,
                decoration: const InputDecoration(labelText: "Health History"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: activityLevel,
                decoration: const InputDecoration(labelText: "Activity Level"),
                items: activityOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => activityLevel = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Update Profile", style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}