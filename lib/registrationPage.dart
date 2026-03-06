import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'otp_verification_page.dart';

class Registrationpage extends StatefulWidget {
  const Registrationpage({super.key});

  @override
  State<Registrationpage> createState() => _RegistrationpageState();
}

class _RegistrationpageState extends State<Registrationpage> {

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final qualificationController = TextEditingController();
  final specializationController = TextEditingController();

  bool visiblePassword = true;
  bool isLoading = false;

  String? selectedRole;

  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$');
    return regex.hasMatch(password);
  }

  Future<void> registerUser() async {

    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedRole == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    if (!isValidPassword(passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must contain uppercase, lowercase, number and special character"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      Uri url;
      Map<String, dynamic> body;

      if (selectedRole == "Customer") {

        url = Uri.parse("http://192.168.100.162:8080/api/v1/customers");

        body = {
          "email": emailController.text.trim(),
          "passwordHash": passwordController.text.trim(),
          "firstName": firstNameController.text.trim(),
          "lastName": lastNameController.text.trim(),
          "phone": phoneController.text.trim()
        };

      } else {

        url = Uri.parse("http://192.168.100.162:8080/api/v1/nutritionists");

        body = {
          "email": emailController.text.trim(),
          "passwordHash": passwordController.text.trim(),
          "firstName": firstNameController.text.trim(),
          "lastName": lastNameController.text.trim(),
          "phone": phoneController.text.trim(),
          "qualification": qualificationController.text.trim(),
          "specialization": specializationController.text.trim()
        };
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationPage(
              email: emailController.text,
              password: passwordController.text,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              phone: phoneController.text,
              role: selectedRole!,
            ),
          ),
        );

      } else {

        String errorMessage = "Registration failed";

        try {
          final data = jsonDecode(response.body);

          if (data["message"] != null) {
            errorMessage = data["message"];
          }

        } catch (e) {
          errorMessage = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {

    return TextField(
      controller: controller,
      obscureText: isPassword ? visiblePassword : false,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),

        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
              visiblePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              visiblePassword = !visiblePassword;
            });
          },
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          SizedBox.expand(
            child: Image.asset(
              "assets/images/food_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Container(color: Colors.black.withOpacity(0.6)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [

                  const SizedBox(height: 80),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),

                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20)),

                    child: Column(
                      children: [

                        buildTextField(firstNameController, "First Name"),
                        const SizedBox(height: 15),

                        buildTextField(lastNameController, "Last Name"),
                        const SizedBox(height: 15),

                        buildTextField(emailController, "Email"),
                        const SizedBox(height: 15),

                        buildTextField(phoneController, "Phone"),
                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: selectedRole,
                          decoration: const InputDecoration(
                              labelText: "I am a",
                              border: OutlineInputBorder()),

                          items: const [
                            DropdownMenuItem(
                              value: "Customer",
                              child: Text("Customer"),
                            ),
                            DropdownMenuItem(
                              value: "Nutritionist",
                              child: Text("Nutritionist"),
                            ),
                          ],

                          onChanged: (value) {
                            setState(() {
                              selectedRole = value;
                            });
                          },
                        ),

                        if (selectedRole == "Nutritionist") ...[

                          const SizedBox(height: 15),

                          buildTextField(
                              qualificationController, "Qualification"),

                          const SizedBox(height: 15),

                          buildTextField(
                              specializationController, "Specialization"),
                        ],

                        const SizedBox(height: 15),

                        buildTextField(passwordController, "Password",
                            isPassword: true),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 50,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE23744),
                            ),

                            onPressed: isLoading ? null : registerUser,

                            child: isLoading
                                ? const CircularProgressIndicator(
                                color: Colors.white)
                                : const Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            const Text("Already have an account? "),

                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },

                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: Color(0xFFE23744),
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}