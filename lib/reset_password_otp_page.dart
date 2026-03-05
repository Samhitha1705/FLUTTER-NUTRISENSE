import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'reset_password_page.dart';
import 'forgot_password_email_page.dart';

class ResetPasswordOtpPage extends StatefulWidget {
  final String email;

  const ResetPasswordOtpPage({super.key, required this.email});

  @override
  State<ResetPasswordOtpPage> createState() => _ResetPasswordOtpPageState();
}

class _ResetPasswordOtpPageState extends State<ResetPasswordOtpPage> {
  final otpController = TextEditingController();
  bool isLoading = false;

  //-------------------------------------------
  // VERIFY OTP
  //-------------------------------------------
  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter OTP")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url =
      Uri.parse("http://10.0.2.2:8080/api/v1/customers/verify-otp");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "otp": otp,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ResetPasswordPage(email: widget.email, otp: otp),
          ),
        );
      } else {
        String message = "Invalid OTP";

        try {
          final body = jsonDecode(response.body);
          message = body["message"] ?? message;
        } catch (_) {}

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  //-------------------------------------------
  // RESEND OTP
  //-------------------------------------------
  Future<void> resendOtp() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
          "http://10.0.2.2:8080/api/v1/customers/resend-otp?email=${widget.email}");

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP sent successfully")));
      } else {
        String errorMessage = "Error sending OTP";

        try {
          final data = jsonDecode(response.body);
          errorMessage = data["message"] ?? errorMessage;
        } catch (_) {}

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  //-------------------------------------------
  // UI
  //-------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: const Color(0xFFE23744),

        // BACK BUTTON → FORGOT PASSWORD PAGE
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const ForgotPasswordEmailPage()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          //----------------------------------
          // Background Image
          //----------------------------------
          SizedBox.expand(
            child: Image.asset(
              "assets/images/food_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Container(color: Colors.black.withOpacity(0.6)),

          //----------------------------------
          // Content
          //----------------------------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 80),

                  const Text(
                    "OTP Verification",
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
                        Text(
                          "Email: ${widget.email}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 20),

                        //----------------------------------
                        // OTP FIELD
                        //----------------------------------
                        TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Enter OTP",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        //----------------------------------
                        // VERIFY BUTTON
                        //----------------------------------
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE23744),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                color: Colors.white)
                                : const Text(
                              "Verify OTP",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        //----------------------------------
                        // RESEND OTP
                        //----------------------------------
                        TextButton(
                          onPressed: isLoading ? null : resendOtp,
                          child: const Text("Resend OTP"),
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