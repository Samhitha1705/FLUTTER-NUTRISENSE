// import 'package:flutter/material.dart';
// import 'plan_manager.dart';
// import 'plans_screen.dart';

// class PremiumFeatureScreen extends StatefulWidget {
//   const PremiumFeatureScreen({super.key});

//   @override
//   State<PremiumFeatureScreen> createState() =>
//       _PremiumFeatureScreenState();
// }

// class _PremiumFeatureScreenState
//     extends State<PremiumFeatureScreen> {

//   String currentPlan = "Basic";
//   DateTime? expiryDate;
//   String? nextPlan;

//   @override
//   void initState() {
//     super.initState();
//     loadSubscription();
//   }

//   Future<void> loadSubscription() async {
//     await PlanManager.checkSubscriptionStatus();

//     currentPlan = await PlanManager.getCurrentPlan();
//     expiryDate = await PlanManager.getExpiryDate();
//     nextPlan = await PlanManager.getNextPlan();

//     setState(() {});
//   }

//   bool hasAccess(String requiredPlan) {
//     return PlanManager.hasAccess(requiredPlan, currentPlan);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Premium Features"),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [

//           Text("Current Plan: $currentPlan",
//               style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold)),

//           if (expiryDate != null)
//             Text(
//                 "Active Till: ${expiryDate!.day}/${expiryDate!.month}/${expiryDate!.year}"),

//           if (nextPlan != null)
//             Text(
//               "Downgrade Scheduled To: $nextPlan",
//               style: const TextStyle(color: Colors.orange),
//             ),

//           const SizedBox(height: 24),

//           const Text("Basic Plan Includes",
//               style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold)),

//           _featureTile("Daily Calorie Tracking",
//               "Track meals and calories", true),

//           _featureTile("Meal Suggestions",
//               "Healthy meal options", true),

//           _featureTile("Nutrition Tips Library",
//               "Access to diet articles", true),

//           const SizedBox(height: 20),

//           const Text("Pro Plan Includes",
//               style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold)),

//           _featureTile("Macro Breakdown",
//               "Protein, carbs and fats tracking",
//               hasAccess("Pro")),

//           _featureTile("Weekly Diet Plan",
//               "7-day structured meal plan",
//               hasAccess("Pro")),

//           _featureTile("Priority Appointment Booking",
//               "Early slot access",
//               hasAccess("Pro")),

//           const SizedBox(height: 20),

//           const Text("Elite Plan Includes",
//               style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold)),

//           _featureTile("Advanced Nutrition Reports",
//               "Monthly health insights",
//               hasAccess("Elite")),

//           _featureTile("Custom Diet Plan",
//               "Fully personalized plan",
//               hasAccess("Elite")),

//           _featureTile("Priority Coach Support",
//               "Premium support access",
//               hasAccess("Elite")),

//           const SizedBox(height: 30),

//           if (currentPlan != "Elite")
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const PlansScreen(),
//                   ),
//                 ).then((_) => loadSubscription());
//               },
//               child: const Text("Upgrade Plan"),
//             )
//         ],
//       ),
//     );
//   }

//   Widget _featureTile(
//       String title,
//       String subtitle,
//       bool unlocked) {
//     return Card(
//       child: ListTile(
//         leading: Icon(
//           unlocked ? Icons.check_circle : Icons.lock,
//           color: unlocked ? Colors.green : Colors.grey,
//         ),
//         title: Text(title),
//         subtitle: Text(subtitle),
//         trailing: unlocked
//             ? const Text("Active",
//             style: TextStyle(color: Colors.green))
//             : const Text("Locked",
//             style: TextStyle(color: Colors.red)),
//       ),
//     );
//   }
// }