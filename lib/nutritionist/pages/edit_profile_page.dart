import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final _formKey = GlobalKey<FormState>();

  final qualificationController = TextEditingController();
  final experienceController = TextEditingController();
  final aadhaarController = TextEditingController();

  bool loading = false;

  Future<void> updateProfile() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    bool success = await ProfileService.updateProfile(
      qualification: qualificationController.text.isEmpty
          ? null
          : qualificationController.text,
      experience: experienceController.text.isEmpty
          ? null
          : int.tryParse(experienceController.text),
      aadhaarRef: aadhaarController.text.isEmpty
          ? null
          : aadhaarController.text,
    );

    setState(() {
      loading = false;
    });

    if (success) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully")),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Update Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF1B4332),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [

              const SizedBox(height: 10),

              /// Qualification
              TextFormField(
                controller: qualificationController,
                decoration: InputDecoration(
                  labelText: "Qualification",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Experience
              TextFormField(
                controller: experienceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Experience (years)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return "Enter valid number";
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// Aadhaar Reference
              TextFormField(
                controller: aadhaarController,
                decoration: InputDecoration(
                  labelText: "Aadhaar Reference",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Update Button
              SizedBox(
                height: 50,

                child: ElevatedButton(

                  onPressed: loading ? null : updateProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4332),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  child: loading
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    "Update Profile",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}