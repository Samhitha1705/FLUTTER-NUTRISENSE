import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  File? imageFile;
  String gender = "Other";
  DateTime? dob;

  final List<String> genderOptions = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString("name") ?? "";
    emailController.text = prefs.getString("email") ?? "";
    phoneController.text = prefs.getString("phone") ?? "";

    String? imagePath = prefs.getString("imagePath");
    if (imagePath != null) imageFile = File(imagePath);

    gender = prefs.getString("gender") ?? "Other";

    String? dobStr = prefs.getString("dob");
    if (dobStr != null) dob = DateTime.tryParse(dobStr);

    setState(() {});
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
                  setState(() => imageFile = File(picked.path));
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
                  setState(() => imageFile = File(picked.path));
                  await prefs.setString("imagePath", picked.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future pickDOB() async {
    DateTime initialDate = dob ?? DateTime(2000);
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() => dob = pickedDate);
    }
  }

  Future saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", nameController.text);
    await prefs.setString("email", emailController.text);
    await prefs.setString("phone", phoneController.text);
    await prefs.setString("gender", gender);
    if (dob != null) {
      await prefs.setString("dob", dob!.toIso8601String());
    }
    if (imageFile != null) {
      await prefs.setString("imagePath", imageFile!.path);
    }

    Navigator.pop(context, true); // Indicate update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null ? const Icon(Icons.person, size: 50) : null,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Gender dropdown
            DropdownButtonFormField<String>(
              value: genderOptions.contains(gender) ? gender : null,
              items: genderOptions
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => gender = val);
              },
              decoration: const InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // DOB picker
            GestureDetector(
              onTap: pickDOB,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: dob != null
                        ? "DOB: ${dob!.day}/${dob!.month}/${dob!.year}"
                        : "Select Date of Birth",
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveProfile,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
