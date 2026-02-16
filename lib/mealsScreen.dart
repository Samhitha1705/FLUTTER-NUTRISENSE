import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/aboutFood.dart';

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
      appBar: AppBar(
        title: const Text("Meals"),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: foodItemList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      category: "Meals",
                    ),
                  ),
                );
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                foodItemList[index],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: const Text(
                "A nutrient-dense meal option packed with essential vitamins and minerals.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // ✅ ZOMATO STYLE PRICE
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹$itemCost",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // ✅ BLACK PRICE
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
