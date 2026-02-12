import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/aboutFood.dart';

class Totalfooditems extends StatelessWidget {
  Totalfooditems({super.key});

  List<String> listBreakfastItems = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPn1P1EB26Hi3JbiVu3Ql-EwTVyF75QMH0jg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPn1P1EB26Hi3JbiVu3Ql-EwTVyF75QMH0jg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScEoI983atQNOB1HP7XDlPTdhkfXh0FPNmlg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQhG7rif2x2ICOFDsA7fk4m1gA6JuxvnP4lA&s",
  ];

  List<String> listLaunchItems = [
    "https://i.ytimg.com/vi/JqAYN1i0a4Y/sddefault.jpg",
    "https://www.connoisseurusveg.com/wp-content/uploads/2025/11/lentil-bowls-sq.jpg",
    "https://horizon.com/wp-content/uploads/cheesy-avocado-toast-recipe.jpg",
    "https://glutenfreegoddessrecipes.com/wp-content/uploads/2024/08/salmon-quinoa-recipe-1723480089.jpg",
  ];

  List<String> listLaunchItemsNames = [
    "Organic Grilled Chicken with Organic Brown Rice & Organic Vegetables",
    "Organic Lentil & Vegetable Bowl",
    "Organic Egg & Organic Avocado on Wholegrain Organic Bread",
    "Organic Salmon with Organic Quinoa & Steamed Greens"
  ];

  int itemCost = 100;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("Morning")),
              Tab(child: Text("Afternoon")),
              Tab(child: Text("Night")),
            ],
          ),
        ),
        body: TabBarView(
          children: [

            /// ---------------- MORNING ----------------
            buildGrid(
              context,
              listBreakfastItems,
              null,
              "Food",
            ),

            /// ---------------- AFTERNOON ----------------
            buildGrid(
              context,
              listLaunchItems,
              listLaunchItemsNames,
              "Food",
            ),

            /// ---------------- NIGHT ----------------
            buildGrid(
              context,
              listBreakfastItems,
              null,
              "Food",
            ),
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
    return Card(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: images.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          String title =
          names != null ? names[index] : "Food Item ${index + 1}";

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Aboutfood(
                    image: images[index],
                    title: title,
                    description: "Healthy and fresh food item",
                    price: itemCost.toString(),
                    category: category, // 🔥 IMPORTANT
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text("Cost: ₹$itemCost"),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
