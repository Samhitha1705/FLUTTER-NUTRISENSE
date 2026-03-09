


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class PlansScreen extends StatefulWidget {
//   PlansScreen({super.key}); // No const here

//   @override
//   State<PlansScreen> createState() => _PlansScreenState();
// }

// class _PlansScreenState extends State<PlansScreen> {
//   bool isLoading = true;
//   bool hasError = false;
//   String errorMessage = "";
//   List<Plan> plans = [];

//   final String publicApiUrl = "http://192.168.100.162:8080/api/v1/membership/plans";

//   @override
//   void initState() {
//     super.initState();
//     fetchPlans();
//   }

//   Future<void> fetchPlans() async {
//     setState(() {
//       isLoading = true;
//       hasError = false;
//       errorMessage = "";
//     });

//     try {
//       final response = await http.get(Uri.parse(publicApiUrl));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         // Expecting data to be a list of plans
//         final List<dynamic> list = data as List<dynamic>;

//         setState(() {
//           plans = list.map((item) => Plan.fromJson(item)).toList();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           hasError = true;
//           errorMessage = "Failed to load plans (${response.statusCode})";
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         hasError = true;
//         errorMessage = "Something went wrong: $e";
//         isLoading = false;
//       });
//     }
//   }

//   Widget buildPlanCard(Plan plan) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               plan.planType,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Price: ₹${plan.price.toStringAsFixed(0)}",
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               "Duration: ${plan.planDuration}",
//             ),
//             const SizedBox(height: 8),
//             Text(
//               plan.description ?? "",
//               style: const TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Membership Plans"),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: fetchPlans,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : hasError
//               ? Center(child: Text(errorMessage))
//               : plans.isEmpty
//                   ? const Center(child: Text("No plans available"))
//                   : ListView.builder(
//                       itemCount: plans.length,
//                       itemBuilder: (context, index) => buildPlanCard(plans[index]),
//                     ),
//     );
//   }
// }

// class Plan {
//   final int id;
//   final String planType;
//   final String planDuration;
//   final double price;
//   final String? description;

//   Plan({
//     required this.id,
//     required this.planType,
//     required this.planDuration,
//     required this.price,
//     this.description,
//   });

//   factory Plan.fromJson(Map<String, dynamic> json) {
//     return Plan(
//       id: json['id'],
//       planType: json['planType'] ?? "Plan",
//       planDuration: json['planDuration'] ?? "-",
//       price: (json['price'] as num).toDouble(),
//       description: json['description'],
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final String baseUrl = "http://192.168.100.162:8080";

  String currentPlan = "NONE";
  DateTime? currentPlanEnd;

  List<Plan> activePlans = [];
  List<Plan> expiredPlans = [];
  List<Plan> cancelledPlans = [];
  List<Plan> historyPlans = [];
  List<Plan> publicPlans = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // ================= LOAD DATA ================= //
  Future<void> loadData() async {
    setState(() => isLoading = true);
    await fetchCurrentMembership();
    await fetchPrivatePlans();
    await fetchPublicPlans();
    setState(() => isLoading = false);
  }

  // ================= FETCH CURRENT PLAN ================= //
  Future<void> fetchCurrentMembership() async {
    final token = await getToken();
    if (token == null) return;

    print("================= TOKEN PLANS =================");
    print(token);
    print("=================================================");

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/customers/membership"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("================= CURRENT PLANS =================");
    print(response.body);
    print("Status code: ${response.statusCode}");
    print("=================================================");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        final plan = data[0];
        setState(() {
          currentPlan = plan["planType"] ?? "NONE";
          currentPlanEnd = DateTime.tryParse(plan["endDate"] ?? "");
        });
      }
    }
  }

  // ================= FETCH PRIVATE PLANS ================= //
  Future<void> fetchPrivatePlans() async {
    final token = await getToken();
    if (token == null) return;

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/customers/membership"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("================= PRIVATE PLANS =================");
    print(response.body);
    print("Status code: ${response.statusCode}");
    print("=================================================");

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
    }
  }

  // ================= FETCH PUBLIC PLANS ================= //
  Future<void> fetchPublicPlans() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/membership/plans"),
    );

    print("================= PUBLIC PLANS =================");
    print(response.body);
    print("Status code: ${response.statusCode}");
    print("=================================================");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data is List ? data : data["plans"];
      setState(() {
        publicPlans = list.map<Plan>((e) => Plan.fromJson(e)).toList();
      });
    }
  }

  // ================= CANCEL PLAN ================= //
  Future<void> cancelPlan(Plan plan) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Cancel"),
        content: Text("Do you want to cancel ${plan.displayName}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("No")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Yes")),
        ],
      ),
    );

    if (!confirmed) return;

    final token = await getToken();
    if (token == null) return;

    final response = await http.patch(
      Uri.parse("$baseUrl/api/v1/customers/membership/${plan.id}/cancel"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("================= CANCEL PLAN =================");
    print(response.body);
    print("Status code: ${response.statusCode}");
    print("=================================================");

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${plan.displayName} cancelled successfully")),
      );
      loadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to cancel ${plan.displayName}")),
      );
    }
  }

  // ================= VIEW PLAN ================= //
  Future<void> viewPlan(Plan plan) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(plan.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price: ₹${plan.price}"),
            Text("Duration: ${plan.planDuration}"),
            Text("Start: ${plan.startDate.isNotEmpty ? plan.startDate : '-'}"),
            Text("Expiry: ${plan.endDate.isNotEmpty ? plan.endDate : '-'}"),
            Text("Status: ${plan.status}"),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  // ================= BUY PLAN ================= //
  Future<void> buyPlan(Plan plan) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Purchase"),
        content: Text("Do you want to buy ${plan.displayName}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Buy")),
        ],
      ),
    );

    if (!confirmed) return;

    final token = await getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token not found, login first")));
      return;
    }

    final now = DateTime.now();
    int monthsToAdd;
    switch (plan.planType) {
      case "ONE_MONTH":
        monthsToAdd = 1;
        break;
      case "THREE_MONTHS":
        monthsToAdd = 3;
        break;
      case "SIX_MONTHS":
        monthsToAdd = 6;
        break;
      case "TWELVE_MONTHS":
        monthsToAdd = 12;
        break;
      default:
        monthsToAdd = 1;
    }

    int targetYear = now.year + ((now.month + monthsToAdd - 1) ~/ 12);
    int targetMonth = ((now.month + monthsToAdd - 1) % 12) + 1;
    int targetDay = now.day;
    int lastDayOfTargetMonth = DateTime(targetYear, targetMonth + 1, 0).day;
    if (targetDay > lastDayOfTargetMonth) targetDay = lastDayOfTargetMonth;

    final endDate = DateTime(targetYear, targetMonth, targetDay);
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final startDate = dateFormatter.format(now);
    final endDateStr = dateFormatter.format(endDate);

    final payload = {"planType": plan.planType, "startDate": startDate, "endDate": endDateStr};

    print("================= BUY PLAN =================");
    print("TOKEN: $token");
    print("Request payload: $payload");
    print("JSON: ${jsonEncode(payload)}");
    print("=================================================");

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/customers/membership"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
        body: jsonEncode(payload),
      );

      print("Response body: ${response.body}");
      print("Status code: ${response.statusCode}");
      print("=================================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${plan.displayName} purchased successfully")));
        loadData();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to purchase ${plan.displayName}")));
      }
    } catch (e) {
      print("Error purchasing plan: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Network error, try again")));
    }
  }

  // ================= PLAN CARD ================= //
  Widget buildPlanCard(Plan plan, {bool isPublic = false}) {
    final now = DateTime.now();
    bool expired = plan.isExpired(now);
    String badge = "";

    if (plan.status == "CANCELLED") badge = "CANCELLED";
    else if (expired) badge = "EXPIRED";
    else if (plan.planType == currentPlan) badge = "ACTIVE";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(plan.displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (badge.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: badge == "ACTIVE"
                        ? Colors.green
                        : badge == "EXPIRED"
                            ? Colors.red
                            : Colors.orange,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(badge, style: const TextStyle(color: Colors.white)),
              )
          ]),
          const SizedBox(height: 8),
          Text("₹${plan.price}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("Duration: ${plan.planDuration}"),
          const SizedBox(height: 8),
          if (plan.startDate.isNotEmpty) Text("Start: ${formatDate(plan.startDate)}"),
          if (plan.endDate.isNotEmpty) Text("Expiry: ${formatDate(plan.endDate)}"),
          const SizedBox(height: 12),
          Row(
            children: [
              if (!isPublic || expired || plan.status == "CANCELLED")
                Expanded(
                    child: ElevatedButton(
                        onPressed: () => viewPlan(plan), child: const Text("View Plan"))),
              if (badge == "ACTIVE")
                Expanded(
                    child: ElevatedButton(
                        onPressed: () => cancelPlan(plan), child: const Text("Cancel Plan"))),
              if (isPublic) Expanded(child: ElevatedButton(onPressed: () => buyPlan(plan), child: const Text("Buy Plan"))),
            ],
          )
        ]),
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

  // ================= UI ================= //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription Plans"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  if (activePlans.isNotEmpty) ...[
                    const Text("Active Plans", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ...activePlans.map((plan) => buildPlanCard(plan)),
                  ],
                  if (publicPlans.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text("Available Plans", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ...publicPlans.map((plan) => buildPlanCard(plan, isPublic: true)),
                  ],
                  if (expiredPlans.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text("Expired Plans", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ...expiredPlans.map((plan) => buildPlanCard(plan)),
                  ],
                  if (cancelledPlans.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text("Cancelled Plans", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ...cancelledPlans.map((plan) => buildPlanCard(plan)),
                  ],
                  if (historyPlans.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text("Plan History", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ...historyPlans.map((plan) => buildPlanCard(plan)),
                  ],
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
                                subtitle: Text("₹${plan.price} | ${plan.planDuration}"),
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
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("No public plans available")));
          }
        },
        label: const Text("Add Plan"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

// ================= PLAN MODEL ================= //
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
      final expiry = DateTime.parse(endDate);
      return expiry.isBefore(now);
    } catch (e) {
      return false;
    }
  }

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()) ?? 0,
      planType: json["planType"] ?? "",
      planDuration: json["planDuration"] ?? "",
      price: (json["price"] as num?)?.toDouble() ?? 0,
      startDate: json["startDate"] ?? "",
      endDate: json["endDate"] ?? "",
      status: json["status"] ?? "",
    );
  }
}