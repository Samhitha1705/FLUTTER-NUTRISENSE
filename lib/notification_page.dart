import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications = prefs.getStringList("notifications") ?? [];
    });
  }

  Future clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("notifications");
    setState(() => notifications.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: clearNotifications,
          )
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
        child: Text("No notifications yet"),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(notifications[index]),
          );
        },
      ),
    );
  }
}