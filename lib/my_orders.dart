import 'package:flutter/material.dart';
import 'order_storage.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

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
                  color: order.status == "Success"
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
