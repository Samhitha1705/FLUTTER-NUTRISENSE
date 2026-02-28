import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalConditionsPage extends StatefulWidget {
  const MedicalConditionsPage({super.key});

  @override
  State<MedicalConditionsPage> createState() =>
      _MedicalConditionsPageState();
}

class _MedicalConditionsPageState
    extends State<MedicalConditionsPage> {

  List<String> selected = [];

  final List<String> conditions = [
    "Diabetes Type 1",
    "Diabetes Type 2",
    "High Blood Pressure",
    "High Cholesterol",
    "Heart Disease",
    "Hypothyroidism",
    "Hyperthyroidism",
    "PCOS",
    "Menopause",
    "Low Testosterone",
    "Prostate Issues",
    "Fatty Liver",
    "IBS",
    "Anemia"
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selected = prefs.getStringList("conditions") ?? [];
    });
  }

  Future save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("conditions", selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Conditions"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: conditions.map((item) {
          return CheckboxListTile(
            title: Text(item),
            value: selected.contains(item),
            onChanged: (val) {
              setState(() {
                val == true
                    ? selected.add(item)
                    : selected.remove(item);
              });
              save();
            },
          );
        }).toList(),
      ),
    );
  }
}