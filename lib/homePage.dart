import 'package:flutter/material.dart';
import 'package:my_app/totalFoodItems.dart';
import 'healthy_screen.dart';
import 'fitness_screen.dart';
import 'diet_screen.dart';

class homePageScreen extends StatefulWidget {
  const homePageScreen({super.key});

  @override
  State<homePageScreen> createState() => _homePageScreenState();
}

class _homePageScreenState extends State<homePageScreen> {
  DateTime? selectedDate;
  String? selectedTime;
  String? selectedNutritionist;

  // store booked slots per date (format: "Nutritionist-Slot")
  final Map<DateTime, Set<String>> bookedSlots = {};

  // list of nutritionists
  final List<String> nutritionists = [
    "Dr. Ananya Sharma",
    "Mr. Rajesh Kumar",
    "Ms. Priya Singh",
  ];

  // -------- GREETING --------
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  // -------- DYNAMIC SLOTS --------
  List<String> generateSlots() {
    final List<String> slots = [];
    for (int h = 9; h <= 19; h++) {
      slots.add("${h.toString().padLeft(2, '0')}:00");
      slots.add("${h.toString().padLeft(2, '0')}:30");
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heroBanner(),
          const SizedBox(height: 24),
          _categories(),
          const SizedBox(height: 28),
          _appointmentCard(),
          if (selectedDate != null &&
              selectedTime != null &&
              selectedNutritionist != null) ...[
            const SizedBox(height: 16),
            _upcomingAppointment(),
          ],
          const SizedBox(height: 32),
          _featuredMeals(),
          const SizedBox(height: 24),
          _followPlanCard(),
        ],
      ),
    );
  }

  // -------- HERO BANNER --------
  Widget _heroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDC830), Color(0xFFF37335)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${getGreeting()} 👋",
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            "Healthy Eating\nMade Simple",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Order smart meals & consult certified nutritionists",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // -------- CATEGORIES --------
  Widget _categories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Our Categories",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _categoryCard(Icons.restaurant, "Meals"),
            _categoryCard(Icons.local_dining, "Healthy Tips"),
            _categoryCard(Icons.fitness_center, "Fitness"),
            _categoryCard(Icons.medical_services, "Diet"),
          ],
        ),
      ],
    );
  }

  Widget _categoryCard(IconData icon, String title) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        if (title == "Meals") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Totalfooditems()),
          );
        } else if (title == "Healthy Tips") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HealthyScreen()),
          );
        } else if (title == "Fitness") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FitnessScreen()),
          );
        } else if (title == "Diet") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DietScreen()),
          );
        }
      },
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // -------- APPOINTMENT CARD --------
  Widget _appointmentCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.green.shade50,
      ),
      child: Row(
        children: [
          const Icon(Icons.health_and_safety, size: 40, color: Colors.green),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Consult a Nutritionist",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("Personal diet & wellness guidance"),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _openAppointmentSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Book"),
          ),
        ],
      ),
    );
  }

  // -------- UPCOMING APPOINTMENT --------
  Widget _upcomingAppointment() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Appointment with $selectedNutritionist on ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year} at $selectedTime",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // -------- FEATURED MEALS --------
  Widget _featuredMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Top Meals",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 170,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _mealCard("Oats & Fruits", "350 kcal"),
              _mealCard("Chicken Salad", "420 kcal"),
              _mealCard("Smoothie Bowl", "280 kcal"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mealCard(String title, String calories) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Totalfooditems()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Center(
                  child: Icon(Icons.fastfood, size: 48, color: Colors.orange),
                ),
              ),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(calories, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  // -------- FOLLOW NUTRITION PLAN --------
  Widget _followPlanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.orange.shade50,
      ),
      child: Row(
        children: [
          const Icon(Icons.assignment_turned_in, size: 40, color: Colors.orange),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Follow your personalized nutrition plan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to nutrition plan screen if implemented
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("View Plan"),
          ),
        ],
      ),
    );
  }

  // -------- BOTTOM SHEET --------
  void _openAppointmentSheet() {
    final slots = generateSlots();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Select Appointment",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // Nutritionist Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Nutritionist",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedNutritionist,
                      items: nutritionists.map((name) {
                        return DropdownMenuItem(
                          value: name,
                          child: Text(name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModal(() {
                          selectedNutritionist = value;
                          selectedDate = null;
                          selectedTime = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Date Picker
                    ListTile(
                      leading: const Icon(Icons.date_range),
                      title: Text(selectedDate == null
                          ? "Select Date"
                          : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"),
                      onTap: selectedNutritionist == null
                          ? null
                          : () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (picked != null) {
                          setModal(() {
                            selectedDate = picked;
                            selectedTime = null;
                          });
                        }
                      },
                    ),

                    // Slots
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: slots.map((slot) {
                        bool isBooked = bookedSlots[selectedDate]?.contains("$selectedNutritionist-$slot") ?? false;

                        return ChoiceChip(
                          label: Text(slot),
                          selected: selectedTime == slot,
                          onSelected: isBooked ? null : (_) => setModal(() => selectedTime = slot),
                          backgroundColor: isBooked ? Colors.red.shade100 : null,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: selectedNutritionist != null &&
                          selectedDate != null &&
                          selectedTime != null
                          ? () {
                        bookedSlots.putIfAbsent(selectedDate!, () => <String>{});
                        bookedSlots[selectedDate!]!.add("$selectedNutritionist-$selectedTime");

                        Navigator.pop(context);
                        setState(() {});
                      }
                          : null,
                      child: const Text("Confirm"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
