import 'package:flutter/material.dart';
import 'plan_manager.dart';
import 'payment_gateway.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  String currentPlan = "Basic";
  String? nextPlan;
  DateTime? expiryDate;

  final Map<String, String> prices = {
    "Basic": "499",
    "Pro": "999",
    "Elite": "1499",
  };

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    await PlanManager.checkSubscriptionStatus();
    currentPlan = await PlanManager.getCurrentPlan();
    nextPlan = await PlanManager.getNextPlan();
    expiryDate = await PlanManager.getExpiryDate();
    setState(() {});
  }

  void handlePlanChange(String newPlan) async {
    if (newPlan == currentPlan) return;

    if (PlanManager.isUpgrade(currentPlan, newPlan)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentGateway(
            title: "$newPlan Subscription",
            image: "",
            orderItemCost: prices[newPlan]!,
            category: "Subscription", token: '',
          ),
        ),
      ).then((success) async {
        if (success == true) {
          await PlanManager.startSubscription(newPlan);
          loadData();
        }
      });
    } else {
      await PlanManager.scheduleDowngrade(newPlan);
      loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Downgrade to $newPlan scheduled for next billing cycle"),
        ),
      );
    }
  }

  Widget buildPlanCard(String plan) {
    bool isCurrent = plan == currentPlan;

    List<String> features = [];

    if (plan == "Basic") {
      features = [
        "Daily Calorie Tracking",
        "Meal Suggestions",
        "Nutrition Tips Library",
      ];
    } else if (plan == "Pro") {
      features = [
        "Everything in Basic",
        "Macro Breakdown",
        "Weekly Diet Plan",
        "Priority Appointment Booking",
      ];
    } else if (plan == "Elite") {
      features = [
        "Everything in Pro",
        "Advanced Nutrition Reports",
        "Custom Diet Plan",
        "Priority Coach Support",
      ];
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("₹${prices[plan]}/month"),
            const SizedBox(height: 10),

            ...features.map(
                  (f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.check,
                        size: 16, color: Colors.green),
                    const SizedBox(width: 6),
                    Expanded(child: Text(f)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: isCurrent ? null : () => handlePlanChange(plan),
              child: Text(isCurrent ? "Current Plan" : "Select Plan"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription Plans"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Current Plan: $currentPlan",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                  if (expiryDate != null)
                    Text(
                        "Active Till: ${expiryDate!.day}-${expiryDate!.month}-${expiryDate!.year}"),
                  if (nextPlan != null)
                    Text(
                      "Downgrade Scheduled: $nextPlan",
                      style:
                      const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            buildPlanCard("Basic"),
            buildPlanCard("Pro"),
            buildPlanCard("Elite"),
          ],
        ),
      ),
    );
  }
}