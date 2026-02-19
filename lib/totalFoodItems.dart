import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Totalfooditems extends StatelessWidget {
  Totalfooditems({super.key});

  final List<String> listBreakfastItems = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPn1P1EB26Hi3JbiVu3Ql-EwTVyF75QMH0jg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPn1P1EB26Hi3JbiVu3Ql-EwTVyF75QMH0jg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScEoI983atQNOB1HP7XDlPTdhkfXh0FPNmlg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQhG7rif2x2ICOFDsA7fk4m1gA6JuxvnP4lA&s",
  ];

  final List<String> listLaunchItems = [
    "https://i.ytimg.com/vi/JqAYN1i0a4Y/sddefault.jpg",
    "https://www.connoisseurusveg.com/wp-content/uploads/2025/11/lentil-bowls-sq.jpg",
    "https://horizon.com/wp-content/uploads/cheesy-avocado-toast-recipe.jpg",
    "https://glutenfreegoddessrecipes.com/wp-content/uploads/2024/08/salmon-quinoa-recipe-1723480089.jpg",
  ];

  final List<String> listLaunchItemsNames = [
    "Organic Grilled Chicken with Organic Brown Rice & Organic Vegetables",
    "Organic Lentil & Vegetable Bowl",
    "Organic Egg & Organic Avocado on Wholegrain Organic Bread",
    "Organic Salmon with Organic Quinoa & Steamed Greens"
  ];

  final int itemCost = 100;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100, // 👈 soft bg
        appBar: AppBar(
          title: const Text("Food Items"),
          elevation: 0,
          bottom: const TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Morning"),
              Tab(text: "Afternoon"),
              Tab(text: "Night"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildGrid(context, listBreakfastItems, null, "Food"),
            buildGrid(context, listLaunchItems, listLaunchItemsNames, "Food"),
            buildGrid(context, listBreakfastItems, null, "Food"),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(
      BuildContext context,
      List<String> images,
      List<String>? names,
      String category,
      ) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: images.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8, // 👈 better proportion
      ),
      itemBuilder: (context, index) {
        String title =
        names != null ? names[index] : "Food Item ${index + 1}";

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              "/aboutFood",
              arguments: {
                "title": title,
                "image": images[index],
                "description": "Healthy and fresh food item",
                "price": itemCost.toString(),
                "category": category,
              },
            );
          },
          child: Card(
            elevation: 6,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18)),
                    child: CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹$itemCost",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
