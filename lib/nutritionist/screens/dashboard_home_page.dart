// import 'package:flutter/material.dart';
// import '../storage/session_manager.dart';
// import 'login_page.dart';
//
// import '../pages/ScheduleAppointmentPage.dart';
// import '../pages/myslots.dart';
// import '../pages/notificationspage.dart';
// import '../pages/ProfilePage.dart';
//
// class DashboardHomePage extends StatefulWidget {
//   const DashboardHomePage({super.key});
//
//   @override
//   State<DashboardHomePage> createState() => _DashboardHomePageState();
// }
//
// class _DashboardHomePageState extends State<DashboardHomePage>
//     with SingleTickerProviderStateMixin {
//
//   late AnimationController _controller;
//   late List<Animation<double>> _cardAnimations;
//
//   String firstName = "";
//
//   // Mock Data
//   final DashboardData _data = const DashboardData(
//     totalClients: 248,
//     todaysAppointments: 7,
//     activeDietPlans: 183,
//     pendingApprovals: 12,
//     totalRevenue: 54820.00,
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     loadName();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//
//     _cardAnimations = List.generate(5, (i) {
//       return CurvedAnimation(
//         parent: _controller,
//         curve: Interval(i * 0.12, 0.6 + i * 0.08, curve: Curves.easeOutBack),
//       );
//     });
//
//     _controller.forward();
//   }
//
//   Future<void> loadName() async {
//     final name = await SessionManager.getFirstName();
//     setState(() {
//       firstName = name ?? "User";
//     });
//   }
//
//   void logout() async {
//     await SessionManager.logout();
//
//     if (!mounted) return;
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const LoginPage(),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   // UI
//
//   @override
//   Widget build(BuildContext context) {
//
//     final size = MediaQuery.of(context).size;
//     final isWide = size.width > 700;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F1EB),
//
//       body: CustomScrollView(
//         slivers: [
//
//           _buildAppBar(),
//
//           SliverPadding(
//             padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
//
//             sliver: SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   _buildGreeting(),
//
//                   const SizedBox(height: 28),
//
//                   _buildDateBadge(),
//
//                   const SizedBox(height: 32),
//
//                   _buildAppointment(),
//
//                   const SizedBox(height: 30),
//
//                   _buildSectionLabel('Overview'),
//
//                   const SizedBox(height: 16),
//
//                   isWide ? _buildWideGrid() : _buildNarrowList(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Appointment Button
//
//   Widget _buildAppointment() {
//
//     return Material(
//       color: Colors.transparent,
//
//       child: InkWell(
//         borderRadius: BorderRadius.circular(18),
//
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const ScheduleAppointmentPage(),
//             ),
//           );
//         },
//
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(20),
//
//           decoration: BoxDecoration(
//             color: const Color(0xFFE9F5EF),
//             borderRadius: BorderRadius.circular(18),
//           ),
//
//           child: Row(
//             children: [
//
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF1B4332),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.add, color: Colors.white, size: 15),
//               ),
//
//               const SizedBox(width: 16),
//
//               const Expanded(
//                 child: Text(
//                   'Appointment Availability',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1B4332),
//                   ),
//                 ),
//               ),
//
//               const Icon(Icons.arrow_forward_ios_rounded,
//                   size: 18, color: Color(0xFF1B4332)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // APP BAR
//
//   SliverAppBar _buildAppBar() {
//
//     return SliverAppBar(
//       expandedHeight: 0,
//       floating: true,
//       snap: true,
//       backgroundColor: const Color(0xFFF4F1EB),
//       elevation: 0,
//
//       title: Row(
//         children: [
//
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: const Color(0xFF1B4332),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(Icons.spa_rounded, color: Colors.white),
//           ),
//
//           const SizedBox(width: 10),
//
//           const Text(
//             'NutriNest',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//               color: Color(0xFF1B4332),
//             ),
//           ),
//         ],
//       ),
//
//       actions: [
//
//         IconButton(
//           icon: const Icon(Icons.notifications_none_rounded),
//           color: const Color(0xFF1B4332),
//
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const NotificationsPage(),
//               ),
//             );
//           },
//         ),
//
//         PopupMenuButton<String>(
//
//           onSelected: (value) {
//
//             if (value == 'profile') {
//
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const ProfilePage(),
//                 ),
//               );
//
//             } else if (value == 'slots') {
//
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const SlotsPage(),
//                 ),
//               );
//
//             } else if (value == 'logout') {
//
//               logout();
//             }
//           },
//
//           itemBuilder: (context) => [
//
//             const PopupMenuItem(
//               value: 'profile',
//               child: Text('My Profile'),
//             ),
//
//             const PopupMenuItem(
//               value: 'slots',
//               child: Text('My Slots'),
//             ),
//
//             const PopupMenuDivider(),
//
//             const PopupMenuItem(
//               value: 'logout',
//               child: Text(
//                 'Logout',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//
//           child: const Padding(
//             padding: EdgeInsets.only(right: 16),
//             child: CircleAvatar(
//               radius: 18,
//               backgroundColor: Color(0xFF52B788),
//               child: Text("Dr"),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Greeting
//
//   Widget _buildGreeting() {
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//
//       children: [
//
//         Text(
//           _getGreeting(),
//           style: const TextStyle(
//             fontSize: 13,
//             color: Color(0xFF6B8F71),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//
//         const SizedBox(height: 4),
//
//         Text(
//           "Dr. $firstName",
//           style: const TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1B4332),
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _getGreeting() {
//
//     final hour = DateTime.now().hour;
//
//     if (hour < 12) return 'GOOD MORNING';
//     if (hour < 17) return 'GOOD AFTERNOON';
//
//     return 'GOOD EVENING';
//   }
//
//   // Date Badge
//
//   Widget _buildDateBadge() {
//
//     final now = DateTime.now();
//
//     return Text(
//       "${now.day}-${now.month}-${now.year}",
//       style: const TextStyle(
//         fontSize: 14,
//         color: Color(0xFF1B4332),
//       ),
//     );
//   }
//
//   // Section Label
//
//   Widget _buildSectionLabel(String text) {
//
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//         color: Color(0xFF1B4332),
//       ),
//     );
//   }
//
//   // GRID
//
//   Widget _buildWideGrid() {
//     return _buildNarrowList();
//   }
//
//   Widget _buildNarrowList() {
//
//     return Column(
//       children: _buildCardList(),
//     );
//   }
//
//   List<Widget> _buildCardList() {
//
//     final specs = [
//
//       _CardSpec(
//         label: "Total Clients",
//         value: _data.totalClients.toString(),
//         emoji: "👥",
//       ),
//
//       _CardSpec(
//         label: "Today's Appointments",
//         value: _data.todaysAppointments.toString(),
//         emoji: "📅",
//       ),
//
//       _CardSpec(
//         label: "Active Diet Plans",
//         value: _data.activeDietPlans.toString(),
//         emoji: "🥗",
//       ),
//
//       _CardSpec(
//         label: "Pending Approvals",
//         value: _data.pendingApprovals.toString(),
//         emoji: "⏳",
//       ),
//
//       _CardSpec(
//         label: "Revenue",
//         value: "₹${_data.totalRevenue}",
//         emoji: "💰",
//       ),
//     ];
//
//     return specs.map((s) => _SummaryCard(spec: s)).toList();
//   }
// }
//
// // DATA MODEL
//
// class DashboardData {
//
//   final int totalClients;
//   final int todaysAppointments;
//   final int activeDietPlans;
//   final int pendingApprovals;
//   final double totalRevenue;
//
//   const DashboardData({
//     required this.totalClients,
//     required this.todaysAppointments,
//     required this.activeDietPlans,
//     required this.pendingApprovals,
//     required this.totalRevenue,
//   });
// }
//
// // CARD MODEL
//
// class _CardSpec {
//
//   final String label;
//   final String value;
//   final String emoji;
//
//   const _CardSpec({
//     required this.label,
//     required this.value,
//     required this.emoji,
//   });
// }
//
// // CARD UI
//
// class _SummaryCard extends StatelessWidget {
//
//   final _CardSpec spec;
//
//   const _SummaryCard({required this.spec});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//
//       child: ListTile(
//
//         leading: Text(
//           spec.emoji,
//           style: const TextStyle(fontSize: 24),
//         ),
//
//         title: Text(spec.label),
//
//         trailing: Text(
//           spec.value,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../auth_storage.dart';
import '../../login_page.dart';

//import '../storage/session_manager.dart';
//import 'login_page.dart';

import 'package:flutter/material.dart';
import '../pages/ScheduleAppointmentPage.dart';
import '../pages/myslots.dart';
import '../pages/notificationspage.dart';
import '../pages/ProfilePage.dart';
import '../../auth_storage.dart'; // make sure AuthStorage is imported

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key});

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _cardAnimations;

  String firstName = "";
  String lastName = "";
  String initials = "";

  final DashboardData _data = const DashboardData(
    totalClients: 248,
    todaysAppointments: 7,
    activeDietPlans: 183,
    pendingApprovals: 12,
    totalRevenue: 54820,
  );

  @override
  void initState() {
    super.initState();
    loadUser();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _cardAnimations = List.generate(
      5,
          (i) => CurvedAnimation(
        parent: _controller,
        curve: Interval(i * 0.12, 0.6 + i * 0.08, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  void loadUser() async {
    final fName = await AuthStorage.getFirstName();
    final lName = await AuthStorage.getLastName();

    setState(() {
      firstName = fName ?? "";
      lastName = lName ?? "";

      if (firstName.isNotEmpty && lastName.isNotEmpty) {
        initials = "${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}";
      }
    });
  }

  void logout() async {
    await AuthStorage.setLoggedIn(false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EB),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 30),
                  _buildAppointment(),
                  const SizedBox(height: 30),
                  const Text(
                    "Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCards(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // AppBar
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: const Color(0xFFF4F1EB),
      elevation: 0,
      title: const Text(
        "NutriNest",
        style: TextStyle(
          color: Color(0xFF1B4332),
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          color: const Color(0xFF1B4332),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotificationsPage(), // removed const
              ),
            );
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "profile") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              );
            } else if (value == "slots") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SlotsPage()),
              );
            } else if (value == "logout") {
              logout();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "profile",
              child: Text("My Profile"),
            ),
            const PopupMenuItem(
              value: "slots",
              child: Text("My Slots"),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: "logout",
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF52B788),
              child: Text(
                initials.isEmpty ? "Dr" : initials,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Greeting
  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Dr. $firstName",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  // Appointment Button
  Widget _buildAppointment() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScheduleAppointmentPage(), // removed const
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F5EF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: const [
            Icon(Icons.add_circle, color: Color(0xFF1B4332)),
            SizedBox(width: 12),
            Text(
              "Appointment Availability",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Dashboard Cards
  Widget _buildCards() {
    final cards = [
      _CardSpec("Total Clients", _data.totalClients.toString(), "👥"),
      _CardSpec("Today's Appointments", _data.todaysAppointments.toString(), "📅"),
      _CardSpec("Active Diet Plans", _data.activeDietPlans.toString(), "🥗"),
      _CardSpec("Pending Approvals", _data.pendingApprovals.toString(), "⏳"),
      _CardSpec("Revenue", "₹${_data.totalRevenue}", "💰"),
    ];

    return Column(
      children: cards.map((c) => _SummaryCard(spec: c)).toList(),
    );
  }
}

// DATA MODEL
class DashboardData {
  final int totalClients;
  final int todaysAppointments;
  final int activeDietPlans;
  final int pendingApprovals;
  final double totalRevenue;

  const DashboardData({
    required this.totalClients,
    required this.todaysAppointments,
    required this.activeDietPlans,
    required this.pendingApprovals,
    required this.totalRevenue,
  });
}

// CARD MODEL
class _CardSpec {
  final String label;
  final String value;
  final String emoji;

  const _CardSpec(this.label, this.value, this.emoji);
}

// CARD UI
class _SummaryCard extends StatelessWidget {
  final _CardSpec spec;

  const _SummaryCard({required this.spec});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Text(
          spec.emoji,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(spec.label),
        trailing: Text(
          spec.value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}