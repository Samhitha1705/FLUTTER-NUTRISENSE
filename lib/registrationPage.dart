import 'package:flutter/material.dart';
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
  bool visiblePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
              child: Image.asset(
                "assets/images/food_bg.jpg",
                fit: BoxFit.cover,
              )),
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
                          decoration:
                          const InputDecoration(labelText: "First Name"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: lastNameController,
                          decoration:
                          const InputDecoration(labelText: "Last Name"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: emailController,
                          decoration:
                          const InputDecoration(labelText: "Email"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: phoneController,
                          decoration:
                          const InputDecoration(labelText: "Phone"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: visiblePassword,
                          decoration: InputDecoration(
                            labelText: "Password",
                            suffixIcon: IconButton(
                              icon: Icon(visiblePassword
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OtpVerificationPage(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    phone: phoneController.text,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
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
                            ),
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