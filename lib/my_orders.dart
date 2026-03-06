import 'package:flutter/material.dart';
import 'order_storage.dart';

class MyOrdersPage extends StatefulWidget {
  final String token; // add this
  const MyOrdersPage({super.key, required this.token}); // require token

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  void initState() {
    super.initState();

    // Simulate refresh
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() {});
      return true;
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Order Placed":
        return Colors.orange;
      case "Preparing":
        return Colors.blue;
      case "Out for Delivery":
        return Colors.purple;
      case "Delivered":
        return Colors.green;
      case "Payment Failed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: globalOrders.isEmpty
          ? const Center(child: Text("No Orders Yet"))
          : ListView.builder(
        itemCount: globalOrders.length,
        itemBuilder: (context, index) {
          final order = globalOrders[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/aboutFood",
                  arguments: {
                    "title": order.title,
                    "image": order.image,
                    "description": "This is your previously ordered item.",
                    "price": order.price.toString(),
                    "category": order.category,
                  },
                );
              },
              child: ListTile(
                leading: Image.network(order.image, width: 60),
                title: Text(order.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("₹${order.price}"),
                    Text("Category: ${order.category}"),
                    Text(
                      "Date: ${order.time.day}-${order.time.month}-${order.time.year}",
                    ),
                  ],
                ),
                trailing: Text(
                  order.status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(order.status),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}