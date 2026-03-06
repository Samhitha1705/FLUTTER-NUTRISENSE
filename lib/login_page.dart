
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password_email_page.dart';
import 'nutritionist/screens/dashboard_home_page.dart';
import 'registrationPage.dart';
import 'statefull.dart';
import 'auth_storage.dart'; // Make sure this exists and has saveUser()

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;
  String? selectedRole;

  Future<void> loginUser() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email, password and role")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Uri url;
      final bodyData = {
        "email": emailController.text.trim(),
        "passwordHash": passwordController.text.trim(), // Use passwordHash for both roles
      };

      if (selectedRole == "Customer") {
        url = Uri.parse("http://192.168.100.162:8080/api/v1/customers/login");
      } else {
        url = Uri.parse("http://192.168.100.162:8080/api/v1/nutritionists/login");
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", true);

        if (selectedRole == "Nutritionist") {
          // Save Nutritionist info
          await AuthStorage.saveUser(data['userDto']);
          await prefs.setString("token", data["accessToken"] ?? "");

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DashboardHomePage()),
                (route) => false,
          );
        } else {
          // Save Customer info
          await AuthStorage.saveUser(data['customerResponseDto']);
          await prefs.setString("token", data["token"] ?? "");

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const StatefulDashboard()),
                (route) => false,
          );
        }
      } else {
        String message = "Login failed";
        try {
          final body = jsonDecode(response.body);
          message = body["message"] ?? message;
        } catch (_) {}
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
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/food_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Please enter your details",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: const UnderlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: selectedRole,
                          decoration: const InputDecoration(
                            hintText: "Login as",
                          ),
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                  const ForgotPasswordEmailPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: isLoading ? null : loginUser,
                            child: isLoading
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Registrationpage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Create an account",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'nutritionist/screens/dashboard_home_page.dart';
// import 'forgot_password_email_page.dart';
// import 'registrationPage.dart';
// import 'statefull.dart';
// import 'nutritionist_dashboard.dart';
// import 'auth_storage.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   bool isPasswordVisible = false;
//   bool isLoading = false;
//
//   String? selectedRole;
//
//   Future<void> loginUser() async {
//
//     if (emailController.text.isEmpty ||
//         passwordController.text.isEmpty ||
//         selectedRole == null) {
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter email, password and role")),
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//
//       Uri url;
//
//       /// CUSTOMER LOGIN API
//       if (selectedRole == "Customer") {
//         url = Uri.parse("http://192.168.100.162:8080/api/v1/customers/login");
//       }
//
//       /// NUTRITIONIST LOGIN API
//       else {
//         url = Uri.parse("http://192.168.100.162:8080/api/v1/nutritionists/login");
//       }
//
//       final response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "email": emailController.text.trim(),
//           "passwordHash": passwordController.text.trim(),
//         }),
//       );
//
//       print("Status Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//
//       setState(() {
//         isLoading = false;
//       });
//
//       if (response.statusCode == 200) {
//
//         /// CUSTOMER DASHBOARD
//         if (selectedRole == "Customer") {
//
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const StatefulDashboard(),
//             ),
//                 (route) => false,
//           );
//         }
//
//         /// NUTRITIONIST DASHBOARD
//         else {
//
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const DashboardHomePage(),
//             ),
//                 (route) => false,
//           );
//         }
//
//       } else {
//
//         String message = "Login failed";
//
//         try {
//           final body = jsonDecode(response.body);
//           message = body["message"] ?? message;
//         } catch (_) {}
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message)),
//         );
//       }
//
//     } catch (e) {
//
//       setState(() {
//         isLoading = false;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       body: Stack(
//         children: [
//
//           SizedBox.expand(
//             child: Image.asset(
//               "assets/images/food_bg.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           Container(color: Colors.black.withOpacity(0.4)),
//
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//
//                 children: [
//
//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Login",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 5),
//
//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Please enter your details",
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 25),
//
//                   Container(
//                     padding: const EdgeInsets.all(20),
//
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//
//                     child: Column(
//                       children: [
//
//                         /// EMAIL
//                         TextField(
//                           controller: emailController,
//                           decoration: const InputDecoration(
//                             hintText: "Email",
//                             border: UnderlineInputBorder(),
//                           ),
//                         ),
//
//                         const SizedBox(height: 20),
//
//                         /// PASSWORD
//                         TextField(
//                           controller: passwordController,
//                           obscureText: !isPasswordVisible,
//
//                           decoration: InputDecoration(
//                             hintText: "Password",
//                             border: const UnderlineInputBorder(),
//
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 isPasswordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                               ),
//
//                               onPressed: () {
//                                 setState(() {
//                                   isPasswordVisible = !isPasswordVisible;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(height: 20),
//
//                         /// ROLE DROPDOWN
//                         DropdownButtonFormField<String>(
//                           value: selectedRole,
//
//                           decoration: const InputDecoration(
//                             hintText: "Login as",
//                           ),
//
//                           items: const [
//
//                             DropdownMenuItem(
//                               value: "Customer",
//                               child: Text("Customer"),
//                             ),
//
//                             DropdownMenuItem(
//                               value: "Nutritionist",
//                               child: Text("Nutritionist"),
//                             ),
//
//                           ],
//
//                           onChanged: (value) {
//                             setState(() {
//                               selectedRole = value;
//                             });
//                           },
//                         ),
//
//                         /// FORGOT PASSWORD
//                         Align(
//                           alignment: Alignment.centerRight,
//
//                           child: TextButton(
//                             onPressed: () {
//
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) =>
//                                   const ForgotPasswordEmailPage(),
//                                 ),
//                               );
//
//                             },
//
//                             child: const Text(
//                               "Forgot Password?",
//                               style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(height: 10),
//
//                         /// LOGIN BUTTON
//                         SizedBox(
//                           width: double.infinity,
//                           height: 45,
//
//                           child: ElevatedButton(
//
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//
//                             onPressed: isLoading ? null : loginUser,
//
//                             child: isLoading
//                                 ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                                 : const Text(
//                               "Login",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(height: 10),
//
//                         /// CREATE ACCOUNT
//                         TextButton(
//                           onPressed: () {
//
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const Registrationpage(),
//                               ),
//                             );
//
//                           },
//
//                           child: const Text(
//                             "Create an account",
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }