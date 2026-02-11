import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/customerReview.dart';
import 'package:my_app/expandWidget.dart';
import 'package:my_app/homePage.dart';
import 'package:my_app/liveCoach.dart';
import 'package:my_app/main.dart';
import 'package:my_app/mealsScreen.dart';
import 'package:my_app/personSuggest.dart';
import 'package:my_app/totalFoodItems.dart';

class maniPage extends StatefulWidget {
  final String phone;

  const maniPage({super.key, required this.phone});

  @override
  State<maniPage> createState() => _maniPageState();
}

class _maniPageState extends State<maniPage> {
  int currentIndex = 0;

  final List<Widget> dashboardScreens = [
    homePageScreen(),
    Totalfooditems(),
    Mealsscreen(),
    liveCoachScreen(),
    Personsuggest(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Dashboard Page"),
        actions: [
          const Icon(Icons.search_outlined, color: Colors.white),

          /// 🔽 FILTER ICON
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                builder: (cxt) {
                  return SizedBox(
                    height: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Filter Data",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const ListTile(
                          leading: CircleAvatar(),
                          title: Text("Filter by Names"),
                        ),
                        const ListTile(
                          leading: CircleAvatar(),
                          title: Text("Filter by Prices"),
                        ),
                        const ListTile(
                          leading: CircleAvatar(),
                          title: Text("Filter by Foods"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Close It",
                            style:
                            TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.filter_alt),
            ),
          ),

          /// 🔐 LOGOUT ICON
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (cxt) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text(
                            "Do you really want to Logout?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (cxt) =>
                                            MyApp(FirstName: '')),
                                        (route) => false);
                              },
                              child: const Text("Yes"))
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.logout))
        ],
      ),

      /// 📂 DRAWER
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 220,
              child: DrawerHeader(
                decoration:
                const BoxDecoration(color: Colors.green),
                child: Center(
                  child: Stack(
                    children: const [
                      CircleAvatar(radius: 45, child: Text("MC")),
                      Positioned(
                        bottom: 4,
                        right: 0,
                        child: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// 🏠 HOME
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (cxt) =>
                              maniPage(phone: widget.phone)),
                          (route) => false);
                },
                icon: const Icon(Icons.home),
                label: const Text("Home")),
            const Divider(),

            /// ⭐ REVIEWS (FIXED HERE)
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (cxt) =>
                        const ReviewsPage()),
                  );
                },
                icon: const Icon(Icons.rate_review_sharp),
                label: const Text("Reviews")),
            const Divider(),

            TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.room_service_outlined),
                label: const Text("My Orders")),
            const Divider(),

            TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.discount),
                label: const Text("Discount")),
            const Divider(),

            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (cxt) =>
                              expandFlex()));
                },
                icon: const Icon(Icons.person),
                label: const Text("Profile")),
            const Divider(),

            TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.explore),
                label: const Text("About Us")),
            const Divider(),

            TextButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (cxt) =>
                              MyApp(FirstName: '')),
                          (route) => false);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout")),
            const Divider()
          ],
        ),
      ),

      /// 🔽 BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        selectedItemColor: Colors.blue,
        selectedFontSize: 18,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: "Foods",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_service_outlined),
            label: "Meals",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_help_outlined),
            label: "Live Coach",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: "You",
          ),
        ],
      ),

      body: dashboardScreens[currentIndex],
    );
  }
}
