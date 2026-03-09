import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  String? selectedGoal;
  String? activityLevel;

  final List<String> goals = [
    "Weight Loss",
    "Weight Gain",
    "Muscle Gain",
    "Fat Loss",
    "Improve Immunity",
    "Heart Healthy Diet",
    "Diabetic Friendly Diet",
    "PCOS Management",
    "Maintain Weight"
  ];

  final List<String> activityLevels = [
    "Sedentary",
    "Lightly Active",
    "Moderately Active",
    "Very Active"
  ];

  @override
  void initState() {
    super.initState();
    loadGoals();
  }

  Future loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedGoal = prefs.getString("goal");
      activityLevel = prefs.getString("activity");
    });
  }

  Future saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("goal", selectedGoal ?? "");
    await prefs.setString("activity", activityLevel ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Goals"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedGoal == "" ? null : selectedGoal,
              decoration: const InputDecoration(
                labelText: "Select Health Goal",
                border: OutlineInputBorder(),
              ),
              items: goals.map((goal) {
                return DropdownMenuItem(
                  value: goal,
                  child: Text(goal),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedGoal = val;
                });
                saveGoals();
              },
            ),
            const SizedBox(height: 25),
            DropdownButtonFormField<String>(
              initialValue: activityLevel == "" ? null : activityLevel,
              decoration: const InputDecoration(
                labelText: "Activity Level",
                border: OutlineInputBorder(),
              ),
              items: activityLevels.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  activityLevel = val;
                });
                saveGoals();
              },
            ),
          ],
        ),
      ),
    );
  }
}
