import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/aboutFood.dart';

class Totalfooditems extends StatelessWidget {

  List<String> listBreakfastItems = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPn1P1EB26Hi3JbiVu3Ql-EwTVyF75QMH0jg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPn1P1EB26Hi3JbiVu3Ql-EwTVyF75QMH0jg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScEoI983atQNOB1HP7XDlPTdhkfXh0FPNmlg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQhG7rif2x2ICOFDsA7fk4m1gA6JuxvnP4lA&s",
  ];
  
  List<String> listLaunchItems =[
    "https://i.ytimg.com/vi/JqAYN1i0a4Y/sddefault.jpg",
    "https://www.connoisseurusveg.com/wp-content/uploads/2025/11/lentil-bowls-sq.jpg",
    "https://horizon.com/wp-content/uploads/cheesy-avocado-toast-recipe.jpg",
    "https://glutenfreegoddessrecipes.com/wp-content/uploads/2024/08/salmon-quinoa-recipe-1723480089.jpg",
  ];

  List<String> listLaunchItemsNames =[
    "Organic Grilled Chicken with Organic Brown Rice & Organic Vegetables",
    "Organic Lentil & Vegetable Bowl",
    "Organic Egg & Organic Avocado on Wholegrain Organic Bread",
    "Organic Salmon with Organic Quinoa & Steamed Greens"
  ];

  Totalfooditems({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [Tab(
            child: Text("Morning")
          ),
          Tab(
            child: Text("Afternoon")
          ),
          Tab(
            child: Text("Night")
          ),
          ]
          ),
        ),
        body:TabBarView(
          children: [
            Card(child: SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap:true,
                // physics: AlwaysScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (cxt,index){
                  return ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (cxt)=> Aboutfood(image: listBreakfastItems[index],
                      title: "About these Food",
                      Description: "Cost £2",)));
                    },
                    title: Card(child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkImage(imageUrl: listBreakfastItems[index]),
                          Text("item $index"),
                          Text("Cost: £2"),
                        ],
                        
                      ),
                    )),
                  );
                }
              ),
            )),
            Card(child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap:true,
                  // physics: AlwaysScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (cxt,index){
                    return ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (cxt)=> Aboutfood(image: listLaunchItems[index],
                        title: listLaunchItemsNames[index],
                        Description: "Cost £2",)));
                      },
                      title: Card(child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(imageUrl: listLaunchItems[index]),
                            Text(listLaunchItemsNames[index]),
                            Text("Cost: £2"),
                          ],
                          
                        ),
                      )),
                    );
                  }
                ),
              )),
            Card(child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap:true,
                  // physics: AlwaysScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (cxt,index){
                    return ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (cxt)=> Aboutfood(image: listBreakfastItems[index],
                        title: "About these Food",
                        Description: "Cost £2",)));
                      },
                      title: Card(child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(imageUrl: listBreakfastItems[index]),
                            Text("item $index"),
                            Text("Cost: £2"),
                          ],
                          
                        ),
                      )),
                    );
                  }
                ),
              ))
        ])
      ),
      // body: GridView.builder(
      // itemCount: 16,
      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      // itemBuilder: (cxt,index){
      //   return ListTile(
      //     onTap: () {
      //       Navigator.push(context, MaterialPageRoute(builder: (cxt)=> Aboutfood(image: "https://kaynutrition.com/wp-content/uploads/2018/11/well-balanced-meal-ideas-9.jpg",
      //       title: "About these Food",
      //       Description: "Cost £2",)));
      //     },
      //     title: Card(child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         CachedNetworkImage(imageUrl: "https://kaynutrition.com/wp-content/uploads/2018/11/well-balanced-meal-ideas-9.jpg"),
      //         Text("item $index"),
      //         Text("Cost: £2"),
      //       ],
      //     )),
      //   );
      // },)

    );
  }
}