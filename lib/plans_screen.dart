import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(home: PlansScreen()));
}

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen>
    with TickerProviderStateMixin {
  final String baseUrl = "http://192.168.100.162:8080";

  String currentPlan = "NONE";
  DateTime? currentPlanEnd;

  List<Plan> activePlans = [];
  List<Plan> expiredPlans = [];
  List<Plan> cancelledPlans = [];
  List<Plan> historyPlans = [];
  List<Plan> publicPlans = [];

  bool isLoading = true;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    loadData();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print("DEBUG: Loaded token: $token");
    return token;
  }

  Future<void> loadData() async {
    print("DEBUG: Loading data...");
    setState(() => isLoading = true);
    await fetchCurrentMembership();
    await fetchPrivatePlans();
    await fetchPublicPlans();
    filterAvailablePlans();
    setState(() => isLoading = false);
    print("DEBUG: Data loading complete.");
  }

  Future<void> fetchCurrentMembership() async {
    final token = await getToken();
    if (token == null) return;

    print("DEBUG: Fetching current membership...");
    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/customers/membership"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("DEBUG: Current membership response: ${response.body}");
    print("DEBUG: Status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        final plan = data[0];
        setState(() {
          currentPlan = plan["planType"] ?? "NONE";
          currentPlanEnd = DateTime.tryParse(plan["endDate"] ?? "");
        });
        print("DEBUG: Current plan: $currentPlan, ends on: $currentPlanEnd");
      }
    }
  }

  Future<void> fetchPrivatePlans() async {
    final token = await getToken();
    if (token == null) return;

    print("DEBUG: Fetching private plans...");
    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/customers/membership"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("DEBUG: Private plans response: ${response.body}");
    print("DEBUG: Status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      final now = DateTime.now();

      activePlans.clear();
      expiredPlans.clear();
      cancelledPlans.clear();
      historyPlans.clear();

      for (var item in list) {
        final plan = Plan.fromJson(item);
        historyPlans.add(plan);

        if (plan.status == "CANCELLED") {
          cancelledPlans.add(plan);
        } else if (plan.isExpired(now)) {
          expiredPlans.add(plan);
        } else {
          activePlans.add(plan);
        }
      }

      print(
          "DEBUG: Active: ${activePlans.length}, Expired: ${expiredPlans.length}, Cancelled: ${cancelledPlans.length}, History: ${historyPlans.length}");
    }
  }

  Future<void> fetchPublicPlans() async {
    print("DEBUG: Fetching public plans...");
    final response =
        await http.get(Uri.parse("$baseUrl/api/v1/membership/plans"));

    print("DEBUG: Public plans response: ${response.body}");
    print("DEBUG: Status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data is List ? data : data["plans"];
      setState(() {
        publicPlans = list.map<Plan>((e) => Plan.fromJson(e)).toList();
      });
      print("DEBUG: Public plans loaded: ${publicPlans.length}");
    }
  }

  void filterAvailablePlans() {
    print(
        "DEBUG: Filtering available plans to exclude active plan: $currentPlan");
    final beforeCount = publicPlans.length;
    publicPlans = publicPlans.where((p) => p.planType != currentPlan).toList();
    print(
        "DEBUG: Available plans filtered: before=$beforeCount, after=${publicPlans.length}");
  }

  Future<void> cancelPlan(Plan plan) async {
    print("DEBUG: Attempting to cancel plan: ${plan.displayName}");
    bool confirmed = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Plan"),
        content: Text("Are you sure you want to cancel ${plan.displayName}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes")),
        ],
      ),
    );

    if (!confirmed) {
      print("DEBUG: Cancel plan cancelled by user.");
      return;
    }

    final token = await getToken();
    if (token == null) return;

    final response = await http.patch(
      Uri.parse("$baseUrl/api/v1/customers/membership/${plan.id}/cancel"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("DEBUG: Cancel plan response: ${response.body}");
    print("DEBUG: Status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${plan.displayName} cancelled successfully")));
      loadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to cancel ${plan.displayName}")));
    }
  }

  Future<void> buyPlan(Plan plan) async {
    print("DEBUG: Attempting to buy plan: ${plan.displayName}");
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Purchase"),
        content: Text("Do you want to buy ${plan.displayName}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Buy")),
        ],
      ),
    );

    if (!confirmed) {
      print("DEBUG: Purchase cancelled by user.");
      return;
    }

    final token = await getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token not found, login first")));
      return;
    }

    final now = DateTime.now();
    DateTime endDate;
    switch (plan.planType) {
      case "ONE_MONTH":
        endDate = DateTime(now.year, now.month + 1, now.day);
        break;
      case "THREE_MONTHS":
        endDate = DateTime(now.year, now.month + 3, now.day);
        break;
      case "SIX_MONTHS":
        endDate = DateTime(now.year, now.month + 6, now.day);
        break;
      case "TWELVE_MONTHS":
        endDate = DateTime(now.year + 1, now.month, now.day);
        break;
      default:
        endDate = DateTime(now.year, now.month + 1, now.day);
    }

    final dateFormatter = DateFormat('yyyy-MM-dd');
    final payload = {
      "planType": plan.planType,
      "startDate": dateFormatter.format(now),
      "endDate": dateFormatter.format(endDate),
    };

    print("DEBUG: Payload JSON: ${jsonEncode(payload)}");
    print("DEBUG: Token: $token");

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/customers/membership"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(payload),
      );

      print("DEBUG: Buy plan response: ${response.body}");
      print("DEBUG: Status code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${plan.displayName} purchased successfully")));
        loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to purchase ${plan.displayName}")));
      }
    } catch (e) {
      print("DEBUG: Network error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Network error, try again")));
    }
  }

  void viewPlan(Plan plan) {
    print("DEBUG: Viewing plan: ${plan.displayName}");
    final now = DateTime.now();
    int? remainingDays;
    if (!plan.isExpired(now) && plan.endDate.isNotEmpty) {
      remainingDays = DateTime.parse(plan.endDate).difference(now).inDays;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(plan.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price: ₹${plan.price}"),
            Text("Duration: ${plan.planDuration}"),
            if (plan.startDate.isNotEmpty)
              Text("Start: ${formatDate(plan.startDate)}"),
            if (plan.endDate.isNotEmpty)
              Text("Expiry: ${formatDate(plan.endDate)}"),
            Text("Status: ${plan.status}"),
            if (remainingDays != null) Text("Remaining days: $remainingDays"),
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }

  Widget buildPlanCard(Plan plan,
      {bool isActive = false,
      bool isPublic = false,
      bool isExpiredOrCancelled = false}) {
    String badge = "";
    if (plan.status == "CANCELLED")
      badge = "CANCELLED";
    else if (plan.isExpired(DateTime.now()))
      badge = "EXPIRED";
    else if (plan.planType == currentPlan) badge = "ACTIVE";

    Color badgeColor = badge == "ACTIVE"
        ? Colors.green
        : badge == "EXPIRED"
            ? Colors.red
            : Colors.orange;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(plan.displayName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (badge.isNotEmpty)
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(20)),
                  child:
                      Text(badge, style: const TextStyle(color: Colors.white)))
          ]),
          const SizedBox(height: 8),
          Text("₹${plan.price}",
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("Duration: ${plan.planDuration}"),
          if (plan.startDate.isNotEmpty)
            Text("Start: ${formatDate(plan.startDate)}"),
          if (plan.endDate.isNotEmpty)
            Text("Expiry: ${formatDate(plan.endDate)}"),
          const SizedBox(height: 12),
          Row(
            children: [
              if (isPublic)
                Expanded(
                    child: ElevatedButton(
                        onPressed: () => buyPlan(plan),
                        child: const Text("Buy Plan"))),
              if (isActive) ...[
                Expanded(
                    child: ElevatedButton(
                        onPressed: () => viewPlan(plan),
                        child: const Text("View Plan"))),
                const SizedBox(width: 10),
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () => cancelPlan(plan),
                        child: const Text("Cancel Plan")))
              ],
              if (isExpiredOrCancelled)
                Expanded(
                    child: ElevatedButton(
                        onPressed: () => viewPlan(plan),
                        child: const Text("View Plan")))
            ],
          )
        ]),
      ),
    );
  }

  Widget buildPlanList(List<Plan> plans,
      {bool isActive = false,
      bool isPublic = false,
      bool isExpiredOrCancelled = false}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plans.length,
      itemBuilder: (_, i) {
        final plan = plans[i];
        return TweenAnimationBuilder<Offset>(
          tween: Tween(begin: const Offset(0, 0.1), end: Offset.zero),
          duration: const Duration(milliseconds: 300),
          child: buildPlanCard(plan,
              isActive: isActive,
              isPublic: isPublic,
              isExpiredOrCancelled: isExpiredOrCancelled),
          builder: (_, offset, child) =>
              Transform.translate(offset: offset, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Subscription Plans"),
          bottom: TabBar(
            controller: tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: "Active"),
              Tab(text: "Available"),
              Tab(text: "Expired"),
              Tab(text: "Cancelled"),
              Tab(text: "History"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (publicPlans.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Subscribe to a Plan"),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView(
                        shrinkWrap: true,
                        children: publicPlans
                            .map((plan) => ListTile(
                                  title: Text(plan.displayName),
                                  subtitle: Text(
                                      "₹${plan.price} | ${plan.planDuration}"),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      buyPlan(plan);
                                    },
                                    child: const Text("Buy"),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  );
                },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No public plans available")),
              );
            }
          },
          label: const Text("Add Plan"),
          icon: const Icon(Icons.add),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: tabController,
                children: [
                  buildPlanList(activePlans, isActive: true),
                  buildPlanList(publicPlans, isPublic: true),
                  buildPlanList(expiredPlans, isExpiredOrCancelled: true),
                  buildPlanList(cancelledPlans, isExpiredOrCancelled: true),
                  buildPlanList(historyPlans, isExpiredOrCancelled: true),
                ],
              ),
      ),
    );
  }

  String formatDate(String date) {
    try {
      return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
    } catch (e) {
      return date;
    }
  }
}

class Plan {
  final int id;
  final String planType;
  final String planDuration;
  final double price;
  final String startDate;
  final String endDate;
  final String status;

  Plan({
    required this.id,
    required this.planType,
    required this.planDuration,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  String get displayName {
    switch (planType) {
      case "ONE_MONTH":
        return "1 Month Plan";
      case "THREE_MONTHS":
        return "3 Months Plan";
      case "SIX_MONTHS":
        return "6 Months Plan";
      case "TWELVE_MONTHS":
        return "12 Months Plan";
      default:
        return planType;
    }
  }

  bool isExpired(DateTime now) {
    try {
      return DateTime.parse(endDate).isBefore(now);
    } catch (_) {
      return false;
    }
  }

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json["id"] is int
          ? json["id"]
          : int.tryParse(json["id"].toString()) ?? 0,
      planType: json["planType"] ?? "",
      planDuration: json["planDuration"] ?? "",
      price: (json["price"] as num?)?.toDouble() ?? 0,
      startDate: json["startDate"] ?? "",
      endDate: json["endDate"] ?? "",
      status: json["status"] ?? "",
    );
  }
}
