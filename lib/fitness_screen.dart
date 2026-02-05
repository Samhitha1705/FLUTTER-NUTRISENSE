import 'package:flutter/material.dart';

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  final List<Map<String, String>> workouts = const [
    {
      "title": "Morning Yoga",
      "description": "Start your day with 15 minutes of gentle stretching and breathing.",
    },
    {
      "title": "Cardio Blast",
      "description": "30 minutes of running, skipping, or cycling to boost heart health.",
    },
    {
      "title": "Strength Training",
      "description": "Use bodyweight or dumbbells to improve strength and endurance.",
    },
    {
      "title": "Evening Walk",
      "description": "Take a relaxing walk after dinner to aid digestion.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness Routines"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange,
                child: const Icon(Icons.fitness_center, color: Colors.white),
              ),
              title: Text(workout["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(workout["description"]!),
              trailing: IconButton(
                icon: const Icon(Icons.play_circle_outline),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
