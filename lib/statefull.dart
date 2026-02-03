import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/homePage.dart';
import 'package:my_app/liveCoach.dart';
import 'package:my_app/main.dart';
import 'package:my_app/mealsScreen.dart';
import 'package:my_app/personSuggest.dart';
import 'package:my_app/totalFoodItems.dart';

// class maniPage extends StatefulWidget {
//   String phone;
//   maniPage({
//     super.key,
//     required this.phone,
//   });
  

//   @override
//   State<maniPage> createState() => _manipageState();
// }

// class _manipageState extends State<maniPage> {

//   Color myContainerColor = Colors.blue;
//   int count = 0;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var phone;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text("StatefulWidget"),
//         ),
//         floatingActionButton: FloatingActionButton(onPressed: (){
//           setState(() {
//             count = count+1;
//           });
//         }, child:const Icon(Icons.add),
//         ),

//         body:Column(children:[Container(
//           width:100,
//           height:100,
//           color:myContainerColor
//           ),
//           ElevatedButton(onPressed: (){
//             myContainerColor = Colors.green;
//             setState(() {
              
//             });
//           }, child: Text("change color to green")),
//           ElevatedButton(onPressed: (){
//             myContainerColor = Colors.pink;
//             setState(() {
              
//             });
//           }, child: Text("change color to pink")),
//           CircleAvatar(
//             radius: 35,
//             child: Text("$count", style: TextStyle(fontSize: 30),),
//           ),
//           Text("Login in as ${phone}"),
//         ]),
//     );
//   }

//   @override
//   void didUpdateWidget(covariant maniPage oldWidget) {
//     // TODO: implement didUpdateWidget
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

// }

class maniPage extends StatefulWidget {

  String phone;
  maniPage({super.key,required this.phone});

  @override
  State<maniPage> createState() => _maniPageState();
}

class _maniPageState extends State<maniPage> {
  int currentIndex = 0;

  List dashboardScreens = [
    homePageScreen(),
    Totalfooditems(),
    Mealsscreen(),
    liveCoachScreen(),
    Personsuggest(),
  ];
  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:Text("Dashboard Page"),
        actions: [
          Icon(Icons.search_outlined, color: Colors.white),
          InkWell(
            onTap: () {
              showModalBottomSheet(context: context, builder: (cxt){
                return Column(
                  children: [
                    Text("Filter Data"),
                    ListTile(
                      leading: CircleAvatar(),
                      title:Text("Filter by Names")),
                    ListTile(
                      leading: CircleAvatar(),
                      title:Text("Filter by Prices")),
                    ListTile(
                      leading: CircleAvatar(),
                      title:Text("Filter by Foods")),

                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Close It"))
                  ],
                );
              });
            },
            child: 
              Icon(Icons.filter_alt),
            
          ),
          IconButton(onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (context) => MyApp(FirstName: ""),
            ), (route)=> false);
          }, icon: Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 220,
              child: DrawerHeader(decoration: BoxDecoration(
                color: Colors.green,
              ),child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(radius:45, child: Text("MC"),
                    ),
                    Positioned(
                      bottom: 4, right: 0,
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
            TextButton.icon(onPressed: (){}, icon:Icon(Icons.room_service_outlined), label: Text("My Orders")),
            Divider(),
            TextButton.icon(onPressed: (){}, icon:Icon(Icons.discount), label: Text("Discount")),
            Divider(),
            TextButton.icon(onPressed: (){},icon:Icon(Icons.person), label: Text("Profile")),
            Divider(),
            TextButton.icon(onPressed: (){},icon:Icon(Icons.explore), label: Text("About Us")),
            Divider(),
            TextButton.icon(onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (cxt)=> MyApp(FirstName: '')),(route)=>false);
            },icon:Icon(Icons.logout), label: Text("Logout")),
            Divider()
          ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        selectedItemColor: Colors.blue,
        selectedFontSize: 18,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (positioned) => {
          currentIndex = positioned,
          setState(() {
            
          }) 
        },
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label:"Home"),
        BottomNavigationBarItem(icon: Icon(Icons.food_bank), label:"Foods"),
        BottomNavigationBarItem(icon: Icon(Icons.room_service_outlined),label:"Meals"),
        BottomNavigationBarItem(icon: Icon(Icons.live_help_outlined),label:"Live Coach"),
        BottomNavigationBarItem(icon:Icon(Icons.person_outline_outlined), label:"You"),
      ]),
      // body: Container(
      //   child: Text("Hi ${widget.phone}"),
      body :dashboardScreens[currentIndex]
    );
  }
}