import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordPage({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  Future<void> resetPassword() async {
    if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter password and confirm password")),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse("http://10.0.2.2:8080/api/v1/customers/reset-password");
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": widget.email,
            "otp": widget.otp,
            "password": passwordController.text,
          }));

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset successfully")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
        );
      } else {
        final body = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body["message"] ?? "Error resetting password")),
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
      body: Stack(
        children: [
          SizedBox.expand(child: Image.asset("assets/images/food_bg.jpg", fit: BoxFit.cover)),
          Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const Text("Reset Password",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        TextField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "New Password",
                            suffixIcon: IconButton(
                              icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: !isPasswordVisible,
                          decoration: const InputDecoration(labelText: "Confirm Password"),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE23744)),
                            onPressed: isLoading ? null : resetPassword,
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("Reset Password", style: TextStyle(color: Colors.white)),
                          ),
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