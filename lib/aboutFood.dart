import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/payment_gateway.dart';

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
          TextButton.icon(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (cxt)=> razorPay(orderItemCost:Description)));
          }, icon:Icon(Icons.arrow_circle_right_outlined),label: Text("Order Now")),
          TextButton.icon(onPressed: (){}, icon: Icon(Icons.add_shopping_cart_outlined), label: Text("Add to Cart Now"))
        ],
      ),
    );
  }
}