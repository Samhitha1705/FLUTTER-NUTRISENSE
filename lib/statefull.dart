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
  String phone;
  maniPage({super.key, required this.phone});

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
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                builder: (cxt) {
                  return Container(
                    height: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,            
                      children: [
                        const Text("Filter Data",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
    
                        ElevatedButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: const Text("Close It",style: TextStyle(fontWeight: FontWeight.bold),))
                      ],
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.filter_alt),
          ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(
          //         builder: (_) => MyApp(FirstName: ""),
          //       ),
          //           (route) => false,
          //     );
          //   },
          //   icon: const Icon(Icons.logout),
          // ),
          IconButton(onPressed: (){
            // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            //   builder: (context) => MyApp(FirstName: ""),
            // ), (route)=> false);
            showDialog(context: context, builder: (cxt){
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Do you really want to Logout?"),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("No")),
                      TextButton(onPressed: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (cxt)=> MyApp(FirstName: '')), (route)=> false);
                      }, child: Text("Yes"))
                    ],
                  );
            });
          }, icon: Icon(Icons.logout))
        ],
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 220,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
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
            // TextButton.(onPressed: (){}, child: Text("Home")),
            TextButton.icon(onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (cxt)=>maniPage(phone: '',)), (route)=>false);
            },icon: Icon(Icons.home), label: Text("Home")),
            Divider(),
            TextButton.icon(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (cxt)=> reviewsPage()));
            }, icon:Icon(Icons.rate_review_sharp), label: Text("Reviews")),
            Divider(),
            TextButton.icon(onPressed: (){}, icon:Icon(Icons.room_service_outlined), label: Text("My Orders")),
            Divider(),
            TextButton.icon(onPressed: (){}, icon:Icon(Icons.discount), label: Text("Discount")),
            Divider(),
            TextButton.icon(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (cxt)=> expandFlex()));
            },icon:Icon(Icons.person), label: Text("Profile")),
            Divider(),
            TextButton.icon(onPressed: (){},icon:Icon(Icons.explore), label: Text("About Us")),
            Divider(),
            TextButton.icon(onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (cxt)=> MyApp(FirstName: '')),(route)=>false);
            },icon:Icon(Icons.logout), label: Text("Logout")),
            Divider()
          ],
        ),
      ),

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