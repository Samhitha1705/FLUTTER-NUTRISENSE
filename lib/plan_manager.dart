import 'package:shared_preferences/shared_preferences.dart';

class PlanManager {
  static const String _currentPlanKey = 'currentPlan';
  static const String _nextPlanKey = 'nextPlan';
  static const String _startDateKey = 'subscriptionStart';
  static const String _expiryDateKey = 'subscriptionExpiry';
  static const String _billingHistoryKey = 'billingHistory';

  static const Map<String, int> planLevels = {
    "Basic": 1,
    "Pro": 2,
    "Elite": 3,
  };

  // ================= GETTERS =================

  static Future<String> getCurrentPlan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentPlanKey) ?? "Basic";
  }

  static Future<String?> getNextPlan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nextPlanKey);
  }

  static Future<DateTime?> getExpiryDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? expiry = prefs.getString(_expiryDateKey);
    if (expiry == null) return null;
    return DateTime.parse(expiry);
  }

  static Future<int> getDaysRemaining() async {
    final expiry = await getExpiryDate();
    if (expiry == null) return 0;

    final now = DateTime.now();
    return expiry.difference(now).inDays;
  }

  // ================= START SUBSCRIPTION =================

  static Future<void> startSubscription(String plan) async {
    final prefs = await SharedPreferences.getInstance();

    DateTime now = DateTime.now();
    DateTime expiry = now.add(const Duration(days: 30));

    await prefs.setString(_currentPlanKey, plan);
    await prefs.setString(_startDateKey, now.toIso8601String());
    await prefs.setString(_expiryDateKey, expiry.toIso8601String());
    await prefs.remove(_nextPlanKey);

    await _addBillingHistory(plan);
  }

  // ================= BILLING HISTORY =================

  static Future<void> _addBillingHistory(String plan) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_billingHistoryKey) ?? [];

    history.add("$plan - ${DateTime.now().toString()}");

    await prefs.setStringList(_billingHistoryKey, history);
  }

  static Future<List<String>> getBillingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_billingHistoryKey) ?? [];
  }

  // ================= DOWNGRADE =================

  static Future<void> scheduleDowngrade(String newPlan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nextPlanKey, newPlan);
  }

  static Future<void> cancelScheduledDowngrade() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nextPlanKey);
  }

  // ================= EXPIRY CHECK =================

  static Future<void> checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? expiryString = prefs.getString(_expiryDateKey);
    if (expiryString == null) return;

    DateTime expiry = DateTime.parse(expiryString);
    DateTime now = DateTime.now();

    if (now.isAfter(expiry)) {
      String? nextPlan = prefs.getString(_nextPlanKey);

      if (nextPlan != null) {
        await startSubscription(nextPlan);
      } else {
        String current = prefs.getString(_currentPlanKey) ?? "Basic";
        await startSubscription(current);
      }
    }
  }

  static bool isUpgrade(String current, String newPlan) {
    return planLevels[newPlan]! > planLevels[current]!;
  }

  static bool isDowngrade(String current, String newPlan) {
    return planLevels[newPlan]! < planLevels[current]!;
  }

  static bool hasAccess(String requiredPlan, String currentPlan) {
    return planLevels[currentPlan]! >= planLevels[requiredPlan]!;
  }
}