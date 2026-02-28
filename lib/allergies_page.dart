import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllergiesPage extends StatefulWidget {
  const AllergiesPage({super.key});

  @override
  State<AllergiesPage> createState() =>
      _AllergiesPageState();
}

class _AllergiesPageState extends State<AllergiesPage> {

  List<String> selected = [];

  final List<String> allergies = [
    "Milk",
    "Lactose",
    "Gluten",
    "Peanuts",
    "Almonds",
    "Cashews",
    "Eggs",
    "Soy",
    "Fish",
    "Shellfish",
    "Sesame",
    "Coconut"
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selected = prefs.getStringList("allergies") ?? [];
    });
  }

  Future save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("allergies", selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Allergies"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: allergies.map((item) {
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