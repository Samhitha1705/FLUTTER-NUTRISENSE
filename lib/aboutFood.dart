import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Aboutfood extends StatelessWidget {
  final String image, title, Description;
  const Aboutfood({super.key, this.title="", this.image="", this.Description=""});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), 
      ),
      body: Column(
        children: [
          Card(child: CachedNetworkImage(imageUrl: image, height: 250, width:double.infinity,)),
          Text(title,style: TextStyle(fontSize: 30)),
          Text(Description),
          TextButton.icon(onPressed: (){}, icon:Icon(Icons.arrow_circle_right_outlined),label: Text("Order Now")),
          TextButton.icon(onPressed: (){}, icon: Icon(Icons.add_shopping_cart_outlined), label: Text("Add to Cart Now"))
        ],
      ),
    );
  }
}