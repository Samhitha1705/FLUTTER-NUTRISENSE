import 'package:flutter/material.dart';
import 'auth_storage.dart';
import 'statefull.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final otpController = TextEditingController();
  final String generatedOtp = "123456";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
              child: Image.asset("assets/images/food_bg.jpg",
                  fit: BoxFit.cover)),
          Container(color: Colors.black.withOpacity(0.6)),
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
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Text("Email: ${widget.email}"),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE23744)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("OTP: $generatedOtp")));
                          },
                          child: const Text(
                            "Get OTP",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: otpController,
                          decoration: const InputDecoration(labelText: "Enter OTP"),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE23744)),
                          onPressed: () async {
                            if (otpController.text == generatedOtp) {
                              await AuthStorage.saveUser(
                                widget.email,
                                widget.password,
                                widget.firstName,
                                widget.lastName,
                                widget.phone,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Registered Successfully")));

                              // ✅ Navigate to Dashboard after OTP
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const StatefulDashboard()),
                                    (route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Invalid OTP")));
                            }
                          },
                          child: const Text(
                            "Verify",
                            style: TextStyle(color: Colors.white),
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