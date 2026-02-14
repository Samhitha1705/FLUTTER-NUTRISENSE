import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'registrationPage.dart';
import 'statefull.dart';
import 'review_provider.dart';   // 👈 ADD THIS

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReviewProvider()), // 👈 ADD THIS
      ],
      child: const NutriApp(),
    ),
  );
}

class NutriApp extends StatelessWidget {
  const NutriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Icons.cyclone,
      duration: 3000,
      splashTransition: SplashTransition.rotationTransition,
      backgroundColor: Colors.blue,
      nextScreen: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Food-Nutri-App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/food-image.png",
              fit: BoxFit.cover,
              height: 250,
            ),
            const SizedBox(height: 30),

            const Text("Enter Phone Number"),
            const SizedBox(height: 8),

            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                hintText: "Enter Phone Number",
                prefixIcon: Icon(Icons.phone_android_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            const Text("Enter Password"),
            const SizedBox(height: 8),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Enter Password",
                prefixIcon: Icon(Icons.password_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const StatefulDashboard(),
                    ),
                        (route) => false,
                  );
                },
                child: const Text("Login"),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const Registrationpage(),
                    ),
                  );
                },
                child: const Text("Don't have an account? Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
