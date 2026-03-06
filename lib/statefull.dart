import 'package:flutter/material.dart';
import 'expandWidget.dart';
import 'my_orders.dart';
import 'cart_page.dart';
import 'address_book_page.dart';

class StatefulDashboard extends StatefulWidget {
  final String token; // Token from login
  const StatefulDashboard({super.key, required this.token});

  @override
  State<StatefulDashboard> createState() => _StatefulDashboardState();
}

class _StatefulDashboardState extends State<StatefulDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExpandWidget(token: widget.token),
                  ),
                );
              },
              child: const Text("Profile"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyOrdersPage(token: widget.token),
                  ),
                );
              },
              child: const Text("My Orders"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartPage(token: widget.token),
                  ),
                );
              },
              child: const Text("Cart"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddressBookPage(token: widget.token),
                  ),
                );
              },
              child: const Text("Address Book"),
            ),
          ],
        ),
      ),
    );
  }
}