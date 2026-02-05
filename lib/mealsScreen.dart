import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/aboutFood.dart';

class Mealsscreen extends StatelessWidget {

  Mealsscreen({super.key});

  List<String> FoodItemList = ["spinach", "Swiss chard", "bok choy", "arugula", "cabbage", "watercress",];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: FoodItemList.length,
        itemBuilder: (context, index) {
        // return Text(FoodItemList[index]);
        //ll
          return Card(
          child: ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (cxt)=> Aboutfood(title: FoodItemList[index],Description: "NA", image: "https://cdn.britannica.com/95/223595-004-36F9B6AF.jpg",)));
            },
            leading: CachedNetworkImage(imageUrl: "https://i.ndtvimg.com/i/2015-04/spinach-600_600x350_51428310656.jpg"),
            title: Text(FoodItemList[index]),
            subtitle: Text("Spinach is a nutrient-dense superfood packed with vitamins A, C, and K, along with iron, folate,potassium, and magnesium, boasting only 7 calories per raw cup", textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 3, ),
            trailing: Icon(Icons.payment),
          ),
        );
      },));
  }
}