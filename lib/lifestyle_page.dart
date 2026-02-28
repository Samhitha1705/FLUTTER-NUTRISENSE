import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifestylePage extends StatefulWidget {
  const LifestylePage({super.key});

  @override
  State<LifestylePage> createState() => _LifestylePageState();
}

class _LifestylePageState extends State<LifestylePage> {

  List<String> selectedLifestyle = [];

  final List<String> lifestyleOptions = [
    "Smoking",
    "Alcohol Consumption",
    "Low Sleep (<6 hrs)",
    "High Stress",
    "Sedentary Job",
    "Night Shift Work",
    "Regular Gym",
    "Yoga Practice",
    "Cardio Workout"
  ];

  @override
  void initState() {
    super.initState();
    loadLifestyle();
  }

  Future loadLifestyle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLifestyle = prefs.getStringList("lifestyle") ?? [];
    });
  }

  Future saveLifestyle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("lifestyle", selectedLifestyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lifestyle"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: lifestyleOptions.map((item) {
          return CheckboxListTile(
            title: Text(item),
            value: selectedLifestyle.contains(item),
            onChanged: (val) {
              setState(() {
                val == true
                    ? selectedLifestyle.add(item)
                    : selectedLifestyle.remove(item);
              });
              saveLifestyle();
            },
          );
        }).toList(),
      ),
    );
  }
}