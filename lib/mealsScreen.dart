import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Mealsscreen extends StatelessWidget {
  Mealsscreen({super.key});

  final List<String> foodItemList = [
    "Spinach",
    "Swiss chard",
    "Bok choy",
    "Arugula",
    "Cabbage",
    "Watercress",
  ];

  final String imageUrl =
      "https://cdn.britannica.com/95/223595-004-36F9B6AF.jpg";

  final int itemCost = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // 👈 soft background
      appBar: AppBar(
        title: const Text("Meals"),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: foodItemList.length,
        itemBuilder: (context, index) {
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            elevation: 5, // 👈 better shadow
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18), // 👈 smoother
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/aboutFood",
                  arguments: {
                    "title": foodItemList[index],
                    "image": imageUrl,
                    "description":
                    "${foodItemList[index]} is a healthy green vegetable rich in vitamins and minerals.",
                    "price": itemCost.toString(),
                    "category": "Meals",
                  },
                );
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 70,   // 👈 slightly bigger
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                foodItemList[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              subtitle: const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "A nutrient-dense meal option packed with essential vitamins and minerals.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "₹$itemCost",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 14, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
