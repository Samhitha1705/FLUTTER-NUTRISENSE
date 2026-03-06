import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,  // Title text color white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1B4332), // AppBar color
        iconTheme: const IconThemeData(
          color: Colors.white, // <-- Back arrow color white
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.notifications, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No new notifications",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}