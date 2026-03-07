import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController goalController = TextEditingController();
  final TextEditingController healthHistoryController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String? selectedActivityLevel;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadExistingData();
  }

  Future loadExistingData() async {
    final prefs = await SharedPreferences.getInstance();
    goalController.text = prefs.getString("goal") ?? "";
    healthHistoryController.text = prefs.getString("healthHistory") ?? "";
    heightController.text = (prefs.getDouble("height") ?? 0).toString();
    weightController.text = (prefs.getDouble("weight") ?? 0).toString();
    selectedActivityLevel = prefs.getString("activityLevel");
  }

  bool validateInputs() {
    final goal = goalController.text.trim();
    final healthHistory = healthHistoryController.text.trim();
    final height = double.tryParse(heightController.text.trim()) ?? -1;
    final weight = double.tryParse(weightController.text.trim()) ?? -1;

    if (goal.isEmpty || goal.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Goal is required and max 100 characters")),
      );
      return false;
    }

    if (healthHistory.isEmpty || healthHistory.length > 2000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Health history is required and max 2000 characters")),
      );
      return false;
    }

    if (height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Height must be a positive number")),
      );
      return false;
    }

    if (weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Weight must be a positive number")),
      );
      return false;
    }

    if (selectedActivityLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an activity level")),
      );
      return false;
    }

    return true;
  }

  Future<void> updateProfile() async {
    if (!validateInputs()) return;

    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    try {
      final response = await http.put(
        Uri.parse("http://192.168.100.162:8080/api/v1/customers/goal"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "goal": goalController.text.trim(),
          "healthHistory": healthHistoryController.text.trim(),
          "height": double.parse(heightController.text.trim()),
          "weight": double.parse(weightController.text.trim()),
          "activityLevel": selectedActivityLevel
        }),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save updated profile locally
        await prefs.setString("goal", data['goal'] ?? "");
        await prefs.setString("healthHistory", data['healthHistory'] ?? "");
        await prefs.setDouble("height", (data['height'] ?? 0).toDouble());
        await prefs.setDouble("weight", (data['weight'] ?? 0).toDouble());
        await prefs.setString("activityLevel", data['activityLevel'] ?? "");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        Navigator.pop(context, true); // trigger refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update failed: ${response.body}")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: goalController,
                decoration: const InputDecoration(
                    labelText: "Goal (max 100 characters)"),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: healthHistoryController,
                decoration: const InputDecoration(
                    labelText: "Health History (max 2000 characters)"),
                maxLines: 3,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Height (cm)"),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Weight (kg)"),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedActivityLevel,
                hint: const Text("Select Activity Level"),
                items: const [
                  DropdownMenuItem(value: "SEDENTARY", child: Text("Sedentary")),
                  DropdownMenuItem(value: "LIGHT", child: Text("Light")),
                  DropdownMenuItem(value: "MODERATE", child: Text("Moderate")),
                  DropdownMenuItem(value: "ACTIVE", child: Text("Active")),
                ],
                onChanged: (val) => setState(() => selectedActivityLevel = val),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: isLoading ? null : updateProfile,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Update Profile",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}