// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:my_app/mealsScreen.dart';

// class liveCoachScreen extends StatefulWidget {
//   const liveCoachScreen({super.key});

//   @override
//   State<liveCoachScreen> createState() => _liveCoachScreenState();
// }

// class _liveCoachScreenState extends State<liveCoachScreen> {
//   final TextEditingController heightController = TextEditingController();
//   final TextEditingController weightController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();

//   bool isConnecting = false;
//   bool isConnected = false;

//   double? bmi;
//   String bmiStatus = "";
//   List<String> recommendations = [];

//   void connectCoach() {
//     if (heightController.text.isEmpty ||
//         weightController.text.isEmpty ||
//         ageController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all details")),
//       );
//       return;
//     }

//     setState(() => isConnecting = true);

//     Timer(const Duration(seconds: 2), () {
//       if (!mounted) return;

//       calculateBMI();
//       setState(() {
//         isConnecting = false;
//         isConnected = true;
//       });
//     });
//   }

//   void calculateBMI() {
//     double heightCm = double.parse(heightController.text);
//     double weightKg = double.parse(weightController.text);

//     double heightM = heightCm / 100;
//     bmi = weightKg / (heightM * heightM);

//     if (bmi! < 18.5) {
//       bmiStatus = "Underweight";
//       recommendations = [
//         "Increase calorie intake",
//         "Protein-rich foods",
//         "Strength training",
//         "Weekly nutritionist follow-up",
//       ];
//     } else if (bmi! < 24.9) {
//       bmiStatus = "Normal";
//       recommendations = [
//         "Balanced diet",
//         "30 min daily exercise",
//         "Hydration focus",
//         "Monthly check-up",
//       ];
//     } else if (bmi! < 29.9) {
//       bmiStatus = "Overweight";
//       recommendations = [
//         "Reduce sugar & carbs",
//         "45 min brisk walking",
//         "Portion control",
//         "Dietician monitoring",
//       ];
//     } else {
//       bmiStatus = "Obese";
//       recommendations = [
//         "Strict medical diet",
//         "Doctor consultation",
//         "Low-impact workouts",
//         "Weekly BMI tracking",
//       ];
//     }
//   }

//   @override
//   void dispose() {
//     heightController.dispose();
//     weightController.dispose();
//     ageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Live Health Coach"),
//         backgroundColor: Colors.green,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: isConnected ? _resultUI() : _inputUI(),
//       ),
//     );
//   }

//   // ---------------- INPUT UI ----------------
//   Widget _inputUI() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Connect with Live Nutritionist",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 20),

//         _inputField("Height (cm)", heightController),
//         _inputField("Weight (kg)", weightController),
//         _inputField("Age", ageController),

//         const SizedBox(height: 20),

//         SizedBox(
//           width: double.infinity,
//           height: 50,
//           child: ElevatedButton(
//             onPressed: isConnecting ? null : connectCoach,
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//             child: isConnecting
//                 ? const CircularProgressIndicator(color: Colors.white)
//                 : const Text("Connect to Live Coach"),
//           ),
//         ),
//       ],
//     );
//   }

//   // ---------------- RESULT UI ----------------
//   Widget _resultUI() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _card(
//           title: "BMI Result",
//           content:
//           "BMI: ${bmi!.toStringAsFixed(1)}\nStatus: $bmiStatus",
//           icon: Icons.monitor_weight,
//         ),

//         _card(
//           title: "Diet & Lifestyle Recommendations",
//           content: recommendations.map((e) => "• $e").join("\n"),
//           icon: Icons.restaurant_menu,
//         ),

//         _card(
//           title: "Coach Advice",
//           content:
//           "Based on your health profile, our nutritionist has curated meals tailored to your BMI and lifestyle.",
//           icon: Icons.health_and_safety,
//         ),

//         const SizedBox(height: 20),

//         // 🔥 NAVIGATE TO MEALS SCREEN
//         SizedBox(
//           width: double.infinity,
//           height: 45,
//           child: ElevatedButton.icon(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => Mealsscreen(),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.restaurant),
//             label: const Text("Order Nutritionist Meals"),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//           ),
//         ),
//       ],
//     );
//   }

//   // ---------------- COMMON WIDGETS ----------------
//   Widget _inputField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: TextField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }

//   Widget _card({
//     required String title,
//     required String content,
//     required IconData icon,
//   }) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Icon(icon, size: 30, color: Colors.green),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 6),
//                   Text(content),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:my_app/listNutrionist.dart';
import 'Nutrionistprofile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class liveCoachScreen extends StatefulWidget {
  final String doctorName, doctorExp, doctorQua;
  const liveCoachScreen(
      {super.key,
      this.doctorName = "",
      this.doctorExp = "",
      this.doctorQua = ""});

  @override
  State<liveCoachScreen> createState() => _liveCoachScreenState();
}

class _liveCoachScreenState extends State<liveCoachScreen> {
  // List<Nutrionist>? Nutrionists;
  var isLoaded = false;
  String myList = "";
  List<dynamic> todoList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataAsync();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  getDataAsync() async {
    setState(() {
      isLoaded = true;
    });
    String? token = await getToken(); // wait for token

    print("token $token");
    http.Response response = await http.get(
      Uri.parse("http://192.168.100.162:8080/api/v1/nutritionists/me"),
      headers: {
        "Accept": "application/json",
        "User-Agent": "Mozilla/5.0",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      myList = response.body;
      print("MyList $myList");
      todoList = [jsonDecode(myList)];
      print(todoList);
      print(todoList.length);
      setState(() {
        isLoaded = false;
      });
    } else {
      print(response.statusCode);
      print("Backend API not fetching");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Text("hello ${todoList["firstName"]}"),
      body: isLoaded
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final doctors = todoList[index];

                return Container(
                  padding: EdgeInsets.all(16),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Nutrionistprofile()));
                    },
                    title: Row(
                      children: [
                        Container(
                          height: 125,
                          width: 125,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      "https://images.unsplash.com/photo-1585358682246-23acb1561f6b?q=80&w=762&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Name: ${doctors["firstName"]}, ${doctors["lastName"]}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      children: [
                                    TextSpan(
                                        text: "Qualification : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: "${doctors["qualification"]}")
                                  ])),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      children: [
                                    TextSpan(
                                        text: "Specialization : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(
                                        text: "${doctors["specialization"]}")
                                  ])),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      children: [
                                    TextSpan(
                                        text: "experience : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(text: "${doctors["experience"]}")
                                  ])),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      children: [
                                    TextSpan(
                                        text: "Email : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(text: "${doctors["email"]}")
                                  ])),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      children: [
                                    TextSpan(
                                        text: "Phone : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(text: "${doctors["phone"]}")
                                  ])),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.greenAccent),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (cxt) =>
                                              Nutrionistprofile()),
                                    );
                                  },
                                  child: Text(
                                    "Check Appointments here",
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
