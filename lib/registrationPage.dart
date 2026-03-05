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

    setState(() {
      isLoading = true;
    });

    try {

      Uri url;
      Map<String, dynamic> body;

      if (selectedRole == "Customer") {

        url = Uri.parse("http://192.168.100.162:8080/api/v1/customers");

        body = {
          "email": emailController.text,
          "passwordHash": passwordController.text,
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "phone": phoneController.text
        };
      } else {

        url = Uri.parse("http://192.168.100.162:8080/api/v1/nutritionists");

        body = {
          "email": emailController.text,
          "password": passwordController.text,
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "phone": phoneController.text,
          "qualification": qualificationController.text,
          "specialization": specializationController.text
        };
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print(response.statusCode);
      print(response.body);

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

                        TextField(
                          controller: firstNameController,
                          decoration: const InputDecoration(labelText: "First Name"),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: lastNameController,
                          decoration: const InputDecoration(labelText: "Last Name"),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: "Email"),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(labelText: "Phone"),
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: selectedRole,
                          decoration: const InputDecoration(labelText: "I am a"),

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

                          TextField(
                            controller: qualificationController,
                            decoration: const InputDecoration(labelText: "Qualification"),
                          ),

                          const SizedBox(height: 15),

                          TextField(
                            controller: specializationController,
                            decoration: const InputDecoration(labelText: "Specialization"),
                          ),
                        ],

                        const SizedBox(height: 15),

                        TextField(
                          controller: passwordController,
                          obscureText: visiblePassword,

                          decoration: InputDecoration(
                            labelText: "Password",

                            suffixIcon: IconButton(
                              icon: Icon(
                                  visiblePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),

                              onPressed: () {
                                setState(() {
                                  visiblePassword = !visiblePassword;
                                });
                              },
                            ),
                          ),
                        ),

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
                                ? const CircularProgressIndicator(color: Colors.white)
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