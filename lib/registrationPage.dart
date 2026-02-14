import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';

class Registrationpage extends StatefulWidget {
  const Registrationpage({super.key});

  @override
  State<Registrationpage> createState() =>
      _RegistrationpageState();
}

class _RegistrationpageState
    extends State<Registrationpage> {
  bool visiblePassword = true;

  TextEditingController nameController =
  TextEditingController();
  TextEditingController emailController =
  TextEditingController();
  TextEditingController passwordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Registration Page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20),

            CachedNetworkImage(
              imageUrl:
              "https://images.unsplash.com/photo-1600577916048-804c9191e36c",
              height: 100,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Enter Your Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Enter Your Email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: passwordController,
              obscureText: visiblePassword,
              decoration: InputDecoration(
                hintText: "Enter Password",
                prefixIcon:
                const Icon(Icons.password_outlined),
                suffixIcon: IconButton(
                  icon: Icon(visiblePassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      visiblePassword =
                      !visiblePassword;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: validate,
              child: const Text("Register"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
              const Text("Already have account?"),
            )
          ],
        ),
      ),
    );
  }

  void validate() {
    if (nameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Enter valid Name");
    } else if (emailController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Enter valid Email");
    } else if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Enter valid Password");
    } else {
      Fluttertoast.showToast(
          msg: "Successfully Registered");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
          const LoginPage(),
        ),
            (route) => false,
      );
    }
  }
}
