import 'package:flutter/material.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  final List<Map<String, String>> diets = const [
    {
      "title": "Low Carb Diet",
      "description": "Reduce carbohydrate intake to manage blood sugar and weight.",
    },
    {
      "title": "Mediterranean Diet",
      "description": "Rich in vegetables, fruits, nuts, and healthy fats.",
    },
    {
      "title": "High Protein Diet",
      "description": "Focus on lean meats, fish, eggs, and legumes for muscle growth.",
    },
    {
      "title": "Intermittent Fasting",
      "description": "Time-restricted eating to promote weight loss and metabolic health.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diet Plans"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: diets.length,
        itemBuilder: (context, index) {
          final diet = diets[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: const Icon(Icons.restaurant_menu, color: Colors.white),
              ),
              title: Text(diet["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(diet["description"]!),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
