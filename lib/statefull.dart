import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/notification_page.dart';
import 'package:my_app/plans_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homePage.dart';
import 'totalFoodItems.dart';
import 'mealsScreen.dart';
import 'liveCoach.dart';
import 'expandWidget.dart';
import 'my_orders.dart';
import 'address_book_page.dart';
import 'login_page.dart';

class StatefulDashboard extends StatefulWidget {
  const StatefulDashboard({super.key});

  @override
  State<StatefulDashboard> createState() => _StatefulDashboardState();
}

class _StatefulDashboardState extends State<StatefulDashboard> {
  int _currentIndex = 0;

  final List<Widget> dashboardScreens = [
    homePageScreen(),
    Totalfooditems(),
    Mealsscreen(),
    liveCoachScreen(),
  ];

  String userName = "User Name";
  String? userImage;

  @override
  void initState() {
    super.initState();
    loadDrawerProfile();
  }

  // Load profile info (name + image)
  Future loadDrawerProfile() async {
    final prefs = await SharedPreferences.getInstance();

    Set<String> keys = prefs.getKeys();

    for (String key in keys) {
      print('$key : ${prefs.get(key)}');
    }

    setState(() {
      userName = prefs.getString("name") ?? "User Name";
      userImage = prefs.getString("imagePath");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NutriSense"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationPage(),
                ),
              );
            },
          ),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (cxt) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("You want to Logout?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (cxt) => LoginPage()),
                                    (route) => false);
                              },
                              child: Text("Yes"))
                        ],
                      );
                    });
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),

      // ---------------- DRAWER ----------------
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 👤 PROFILE IMAGE + NAME
              GestureDetector(
                onTap: () async {
                  bool? updated = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExpandWidget()),
                  );
                  // Reload profile after returning
                  if (updated == true) loadDrawerProfile();
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.green,
                      backgroundImage: userImage != null
                          ? FileImage(File(userImage!))
                          : null,
                      child: userImage == null
                          ? const Icon(Icons.person,
                              size: 40, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "View Profile",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // 🛒 Your Orders
              ListTile(
                leading: const Icon(Icons.shopping_bag_outlined),
                title: const Text("Your Orders"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyOrdersPage()),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.subscriptions),
                title: const Text("Your Subscriptions"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (cxt) => PlansScreen()),
                  );
                },
              ),
              // 📍 Address Book
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: const Text("Address Book"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddressBookPage()),
                  );
                },
              ),

              // 🚪 Logout
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (cxt) {
                        return AlertDialog(
                          title: Text("Logout"),
                          content: Text("You want to Logout?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (cxt) => LoginPage()),
                                      (route) => false);
                                },
                                child: Text("Yes"))
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: SafeArea(
        child: dashboardScreens[_currentIndex],
      ),

      // ---------------- BOTTOM NAVIGATION ----------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: "Foods"),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: "Meals"),
          BottomNavigationBarItem(
              icon: Icon(Icons.support_agent), label: "Live Coach"),
        ],
      ),
    );
  }
}
