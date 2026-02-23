import 'package:flutter/material.dart';
import 'dart:async';
import 'mealsScreen.dart'; // 👈 your existing file (unchanged)

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  final StreamController<List<Map<String, String>>> _dietStreamController =
  StreamController<List<Map<String, String>>>.broadcast();

  final List<Map<String, String>> diets = [
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
      "description": "Focus on lean meats, fish, eggs, and legumes.",
    },
    {
      "title": "Intermittent Fasting",
      "description": "Time-restricted eating for metabolic health.",
    },
    {
      "title": "Vegan Diet",
      "description": "Plant-based foods for overall health and energy.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _dietStreamController.add(diets);

    // optional dynamic update
    Future.delayed(const Duration(seconds: 5), () {
      diets.add({
        "title": "Keto Diet",
        "description": "High-fat, low-carb lifestyle.",
      });
      _dietStreamController.add(List.from(diets));
    });
  }

  @override
  void dispose() {
    _dietStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diet Plans"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: _dietStreamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final dietList = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: dietList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final diet = dietList[index];

                return _DietCard(
                  title: diet["title"]!,
                  description: diet["description"]!,
                  color: Colors.primaries[index % Colors.primaries.length],
                  onTap: () {
                    // ✅ EXACT CLASS NAME — NO CHANGE TO MEALS FILE
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Mealsscreen(),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _DietCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _DietCard({
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.restaurant_menu,
                    color: Colors.white, size: 32),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(
                    description,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.arrow_forward_ios,
                      color: Colors.white70, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}