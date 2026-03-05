import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'reset_password_otp_page.dart';
import 'login_page.dart';

class ForgotPasswordEmailPage extends StatefulWidget {
  const ForgotPasswordEmailPage({super.key});

  @override
  State<ForgotPasswordEmailPage> createState() =>
      _ForgotPasswordEmailPageState();
}

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {
  final emailController = TextEditingController();
  bool isLoading = false;

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter your email")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
          "http://10.0.2.2:8080/api/v1/customers/forget-password?email=$email");

      final response = await http.post(url);

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 202) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordOtpPage(email: email),
          ),
        );
      } else {
        String message = "Error sending OTP";

        try {
          final body = jsonDecode(response.body);
          message = body["message"] ?? message;
        } catch (_) {
          message = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //---------------------------------------------------
      // BACK BUTTON APPBAR
      //---------------------------------------------------
      appBar: AppBar(
        backgroundColor: const Color(0xFFE23744),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginPage(),
              ),
            );
          },
        ),
        title: const Text("Forgot Password"),
      ),

      //---------------------------------------------------
      // BODY
      //---------------------------------------------------
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/food_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 80),

                  const Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: "Enter Email",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : sendOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE23744),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text(
                              "Send OTP",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}