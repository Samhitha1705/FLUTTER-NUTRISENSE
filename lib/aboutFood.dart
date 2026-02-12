import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'payment_gateway.dart';

class Aboutfood extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String price;
  final String category;

  const Aboutfood({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: image,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 10),
          Text(description),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentGateway(
                    title: title,
                    image: image,
                    orderItemCost: price,
                    category: category,
                  ),
                ),
              );
            },
            child: const Text("Order Now"),
          )
        ],
      ),
    );
  }
}
