import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/aboutFood.dart';

class Mealsscreen extends StatelessWidget {
  Mealsscreen({super.key});

  List<String> foodItemList = [
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
      appBar: AppBar(
        title: const Text("Meals"),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: foodItemList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Aboutfood(
                      title: foodItemList[index],
                      image: imageUrl,
                      description:
                      "${foodItemList[index]} is a healthy green vegetable rich in vitamins and minerals.",
                      price: itemCost.toString(),
                      category: "Meals", // 🔥 IMPORTANT
                    ),
                  ),
                );
              },
              leading: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 60,
                fit: BoxFit.cover,
              ),
              title: Text(foodItemList[index]),
              subtitle: const Text(
                "A nutrient-dense meal option packed with essential vitamins and minerals.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.payment),
            ),
          );
        },
      ),
    );
  }
}
