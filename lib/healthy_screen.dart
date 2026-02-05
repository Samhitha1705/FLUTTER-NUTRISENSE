import 'package:flutter/material.dart';

class HealthyScreen extends StatelessWidget {
  const HealthyScreen({super.key});

  final List<Map<String, String>> tips = const [
    {
      "title": "Drink More Water",
      "description": "Stay hydrated to boost metabolism and flush out toxins."
    },
    {
      "title": "Eat More Vegetables",
      "description": "Vegetables are rich in vitamins, minerals, and fiber."
    },
    {
      "title": "Get Enough Sleep",
      "description": "Sleep 7-9 hours daily for optimal body recovery."
    },
    {
      "title": "Limit Sugar Intake",
      "description": "Reduce sugary snacks to maintain healthy weight."
    },
    {
      "title": "Practice Mindfulness",
      "description": "Meditation and breathing exercises reduce stress."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Healthy Tips"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: const Icon(Icons.health_and_safety, color: Colors.white),
              ),
              title: Text(tip["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(tip["description"]!),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
