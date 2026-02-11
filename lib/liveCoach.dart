import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/mealsScreen.dart';

class liveCoachScreen extends StatefulWidget {
  const liveCoachScreen({super.key});

  @override
  State<liveCoachScreen> createState() => _liveCoachScreenState();
}

class _liveCoachScreenState extends State<liveCoachScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  bool isConnecting = false;
  bool isConnected = false;

  double? bmi;
  String bmiStatus = "";
  List<String> recommendations = [];

  void connectCoach() {
    if (heightController.text.isEmpty ||
        weightController.text.isEmpty ||
        ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all details")),
      );
      return;
    }

    setState(() => isConnecting = true);

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      calculateBMI();
      setState(() {
        isConnecting = false;
        isConnected = true;
      });
    });
  }

  void calculateBMI() {
    double heightCm = double.parse(heightController.text);
    double weightKg = double.parse(weightController.text);

    double heightM = heightCm / 100;
    bmi = weightKg / (heightM * heightM);

    if (bmi! < 18.5) {
      bmiStatus = "Underweight";
      recommendations = [
        "Increase calorie intake",
        "Protein-rich foods",
        "Strength training",
        "Weekly nutritionist follow-up",
      ];
    } else if (bmi! < 24.9) {
      bmiStatus = "Normal";
      recommendations = [
        "Balanced diet",
        "30 min daily exercise",
        "Hydration focus",
        "Monthly check-up",
      ];
    } else if (bmi! < 29.9) {
      bmiStatus = "Overweight";
      recommendations = [
        "Reduce sugar & carbs",
        "45 min brisk walking",
        "Portion control",
        "Dietician monitoring",
      ];
    } else {
      bmiStatus = "Obese";
      recommendations = [
        "Strict medical diet",
        "Doctor consultation",
        "Low-impact workouts",
        "Weekly BMI tracking",
      ];
    }
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Health Coach"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isConnected ? _resultUI() : _inputUI(),
      ),
    );
  }

  // ---------------- INPUT UI ----------------
  Widget _inputUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Connect with Live Nutritionist",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        _inputField("Height (cm)", heightController),
        _inputField("Weight (kg)", weightController),
        _inputField("Age", ageController),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isConnecting ? null : connectCoach,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: isConnecting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Connect to Live Coach"),
          ),
        ),
      ],
    );
  }

  // ---------------- RESULT UI ----------------
  Widget _resultUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _card(
          title: "BMI Result",
          content:
          "BMI: ${bmi!.toStringAsFixed(1)}\nStatus: $bmiStatus",
          icon: Icons.monitor_weight,
        ),

        _card(
          title: "Diet & Lifestyle Recommendations",
          content: recommendations.map((e) => "• $e").join("\n"),
          icon: Icons.restaurant_menu,
        ),

        _card(
          title: "Coach Advice",
          content:
          "Based on your health profile, our nutritionist has curated meals tailored to your BMI and lifestyle.",
          icon: Icons.health_and_safety,
        ),

        const SizedBox(height: 20),

        // 🔥 NAVIGATE TO MEALS SCREEN
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Mealsscreen(),
                ),
              );
            },
            icon: const Icon(Icons.restaurant),
            label: const Text("Order Nutritionist Meals"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
        ),
      ],
    );
  }

  // ---------------- COMMON WIDGETS ----------------
  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
