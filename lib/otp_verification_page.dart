import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';
import 'login_page.dart';
import 'registrationPage.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String role;

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {

  final otpController = TextEditingController();
  bool isLoading = false;

  //----------------------------------
  // VERIFY OTP
  //----------------------------------

  Future<void> verifyOtp() async {

    String otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter OTP")),
      );
      return;
    }

    if (otp.length != 6 || !RegExp(r'^[0-9]{6}$').hasMatch(otp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP must be exactly 6 digits")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      String apiUrl;

      if (widget.role == "Nutritionist") {
        apiUrl = "http://192.168.100.162:8080/api/v1/nutritionists/verify-otp";
      } else {
        apiUrl = "http://192.168.100.162:8080/api/v1/customers/verify-otp";
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": widget.email,
          "otp": otp,
        }),
      );

      setState(() {
        isLoading = false;
      });

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {

        await AuthStorage.saveUser({
          "email": widget.email,
          "password": widget.password,
          "firstName": widget.firstName,
          "lastName": widget.lastName,
          "phone": widget.phone,
          "role": widget.role,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registered Successfully")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
        );

      } else {

        String message = "Invalid OTP";

        if (response.body.isNotEmpty) {
          try {
            final body = jsonDecode(response.body);
            message = body["message"] ?? message;
          } catch (_) {
            message = response.body;
          }
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

  //----------------------------------
  // RESEND OTP
  //----------------------------------

  Future<void> resendOtp() async {

    setState(() {
      isLoading = true;
    });

    try {

      String apiUrl;

      if (widget.role == "Nutritionist") {
        apiUrl =
        "http://192.168.100.162:8080/api/v1/nutritionists/resend-otp?email=${widget.email}";
      } else {
        apiUrl =
        "http://192.168.100.162:8080/api/v1/customers/resend-otp?email=${widget.email}";
      }

      final response = await http.put(Uri.parse(apiUrl));

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP resent successfully")),
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
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

  //----------------------------------
  // UI
  //----------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: const Color(0xFFE23744),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const Registrationpage(),
              ),
            );
          },
        ),
      ),

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
                    "OTP Verification",
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
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      children: [

                        Text(
                          "Email: ${widget.email}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,

                          decoration: const InputDecoration(
                            labelText: "Enter OTP",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 50,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE23744),
                            ),

                            onPressed: isLoading ? null : verifyOtp,

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

                        TextButton(
                          onPressed: isLoading ? null : resendOtp,
                          child: const Text("Resend OTP"),
                        ),

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