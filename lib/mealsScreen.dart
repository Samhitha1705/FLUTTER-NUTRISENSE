import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mealsscreen extends StatefulWidget {
  const Mealsscreen({super.key});

  @override
  State<Mealsscreen> createState() => _MealsscreenState();
}

class _MealsscreenState extends State<Mealsscreen> {
  List allMeals = [];
  List filteredMeals = [];
  List categories = [];
  bool isLoading = true;
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await http.get(
        Uri.parse("http://192.168.100.162:8080/api/v1/meals"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List meals = data["content"];
        Set<String> categorySet = {"All"};
        for (var meal in meals) categorySet.add(meal["category"]);

        setState(() {
          allMeals = meals;
          filteredMeals = meals;
          categories = categorySet.toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void filterMeals(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "All") {
        filteredMeals = allMeals;
      } else {
        filteredMeals =
            allMeals.where((meal) => meal["category"] == category).toList();
      }
    });
  }

  Future<Map<String, dynamic>?> fetchMealDetail(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await http.get(
        Uri.parse("http://192.168.100.162:8080/api/v1/meals/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Error fetching detail: $e");
      return null;
    }
  }

  void showMealDetail(int id) async {
    int quantity = 1;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => FutureBuilder<Map<String, dynamic>?>(
          future: fetchMealDetail(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: 250,
                  child: Center(child: CircularProgressIndicator()));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return SizedBox(
                  height: 150,
                  child: Center(child: Text("Meal details not available")));
            }

            final meal = snapshot.data!;
            return Padding(
              padding: EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(meal["name"],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  CachedNetworkImage(
                    imageUrl: meal["image"] ?? "https://via.placeholder.com/200",
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(height: 180, color: Colors.grey.shade200),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.fastfood, size: 100, color: Colors.orange),
                  ),
                  const SizedBox(height: 12),
                  Text("Category: ${meal["category"]}"),
                  Text("Type: ${meal["itemType"]}"),
                  Text("Calories: ${meal["calories"]} kcal"),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Price: ₹${meal["price"]}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (quantity > 1) {
                                  setModalState(() => quantity--);
                                }
                              },
                              icon: Icon(Icons.remove_circle_outline)),
                          Text(quantity.toString(),
                              style: TextStyle(fontSize: 16)),
                          IconButton(
                              onPressed: () {
                                setModalState(() => quantity++);
                              },
                              icon: Icon(Icons.add_circle_outline)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("Allergens: ${meal["allergens"] ?? "None"}",
                      style: TextStyle(color: Colors.redAccent)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "$quantity x ${meal["name"]} added to cart")),
                        );
                      },
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text("Add to Cart"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Meals"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Category Chips
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          selectedColor: Colors.orange.shade300,
                          onSelected: (_) => filterMeals(category),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: filteredMeals.isEmpty
                      ? const Center(child: Text("No Meals Available"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: filteredMeals.length,
                          itemBuilder: (context, index) {
                            final meal = filteredMeals[index];
                            return GestureDetector(
                              onTap: () => showMealDetail(meal["id"]),
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                elevation: 5,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          bottomLeft: Radius.circular(16)),
                                      child: CachedNetworkImage(
                                        imageUrl: meal["image"] ??
                                            "https://via.placeholder.com/100",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          color: Colors.grey.shade200,
                                          child: const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.fastfood,
                                              color: Colors.orange),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(meal["name"],
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(
                                                "${meal["category"]} | ${meal["itemType"]}"),
                                            const SizedBox(height: 4),
                                            Text(
                                                "Calories: ${meal["calories"]} kcal"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Text("₹${meal["price"]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}