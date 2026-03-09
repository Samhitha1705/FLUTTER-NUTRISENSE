import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'review_provider.dart';
import 'routes.dart';
import 'login_page.dart'; // ✅ ADDED THIS

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: const NutriApp(),
    ),
  );
}

class NutriApp extends StatelessWidget {
  const NutriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Food Nutri App",
      theme: ThemeData(
        primaryColor: const Color(0xFFE23744),
        scaffoldBackgroundColor: Colors.white,
      ),
      onGenerateRoute: onGenerateRoute,
      initialRoute: "/",
    );
  }
}

//////////////////////////////////////////////////////////
// SPLASH SCREEN
//////////////////////////////////////////////////////////

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: const Text(
        "Nutri",
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      duration: 2000,
      backgroundColor: const Color(0xFFE23744),
      nextScreen: const LoginPage(), // ✅ Now comes from login_page.dart
    );
  }
}
