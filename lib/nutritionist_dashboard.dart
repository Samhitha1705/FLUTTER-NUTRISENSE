import 'package:flutter/material.dart';
import 'login_page.dart';

class NutritionistDashboard extends StatelessWidget {
  const NutritionistDashboard({super.key});

  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  Widget dashboardCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.green),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutritionist Dashboard"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [

            dashboardCard(
              icon: Icons.people,
              title: "My Clients",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Clients page coming soon")),
                );
              },
            ),

            dashboardCard(
              icon: Icons.food_bank,
              title: "Diet Plans",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Diet plans page coming soon")),
                );
              },
            ),

            dashboardCard(
              icon: Icons.calendar_month,
              title: "Appointments",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Appointments page coming soon")),
                );
              },
            ),

            dashboardCard(
              icon: Icons.person,
              title: "Profile",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile page coming soon")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}