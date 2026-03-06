// import 'package:flutter/material.dart';
// import 'slot_storage.dart';

// class SlotsPage extends StatelessWidget {
//   const SlotsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final allData = SlotStorage.allSlots;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F1EB),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1B4332),
//         title: const Text(
//           "My Slots",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: allData.isEmpty
//           ? const Center(child: Text("No Slots Added Yet"))
//           : ListView.builder(
//               padding: const EdgeInsets.all(20),
//               itemCount: allData.length,
//               itemBuilder: (context, index) {
//                 final item = allData[index];

//                 final DateTime date = item["date"];

//                 final List<Map<String, TimeOfDay>> slots =
//                     List<Map<String, TimeOfDay>>.from(item["slots"]);

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Date: ${date.day}/${date.month}/${date.year}",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 10),

//                     ...slots.map((slot) {
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 8),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           "${slot["start"]!.format(context)} - ${slot["end"]!.format(context)}",
//                         ),
//                       );
//                     }).toList(),

//                     const SizedBox(height: 20),
//                   ],
//                 );
//               },
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'slot_storage.dart';

// class SlotsPage extends StatefulWidget {
//   const SlotsPage({super.key});

//   @override
//   State<SlotsPage> createState() => _SlotsPageState();
// }

// class _SlotsPageState extends State<SlotsPage> {
//   DateTime? _selectedDate;

//   @override
//   Widget build(BuildContext context) {
//     final allData = SlotStorage.allSlots;

//     // Filter slots for selected date, if any
//     final filteredData = _selectedDate == null
//         ? allData
//         : allData.where((item) {
//             final date = item["date"] as DateTime;
//             return date.year == _selectedDate!.year &&
//                 date.month == _selectedDate!.month &&
//                 date.day == _selectedDate!.day;
//           }).toList();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F1EB),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1B4332),
//         elevation: 0,
//         title: const Text(
//           "My Availability Slots",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_today),
//             onPressed: _pickDate,
//             tooltip: "Select Date",
//           ),
//         ],
//       ),
//       body: filteredData.isEmpty
//           ? _buildEmptyState()
//           : ListView.builder(
//               padding: const EdgeInsets.all(20),
//               itemCount: filteredData.length,
//               itemBuilder: (context, index) {
//                 final item = filteredData[index];
//                 final date = item["date"] as DateTime;
//                 final slots = List<Map<String, TimeOfDay>>.from(item["slots"]);

//                 return _buildDateCard(context, date, slots);
//               },
//             ),
//     );
//   }

//   /// Date Picker
//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//       lastDate: DateTime(2027),
//     );

//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   Widget _buildEmptyState() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.event_busy, size: 60, color: Colors.grey),
//           SizedBox(height: 16),
//           Text(
//             "No Availability Added Yet",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateCard(
//       BuildContext context, DateTime date, List<Map<String, TimeOfDay>> slots) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Date Header
//           Row(
//             children: [
//               const Icon(
//                 Icons.calendar_today,
//                 size: 18,
//                 color: Color(0xFF1B4332),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 "${date.day}/${date.month}/${date.year}",
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1B4332),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 15),
//           const Divider(),
//           const SizedBox(height: 10),

//           /// Slots List
//           ...slots.map((slot) {
//             return Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE9F5EF),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.access_time,
//                     size: 18,
//                     color: Color(0xFF1B4332),
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     "${slot["start"]!.format(context)}  -  ${slot["end"]!.format(context)}",
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1B4332),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'slot_storage.dart';

// class SlotsPage extends StatefulWidget {
//   const SlotsPage({super.key});

//   @override
//   State<SlotsPage> createState() => _SlotsPageState();
// }

// class _SlotsPageState extends State<SlotsPage> {
//   DateTime? _selectedDate;

//   /// Get slots for selected date
//   List<Map<String, dynamic>> _getFilteredSlots() {
//     if (_selectedDate == null) return [];

//     return SlotStorage.allSlots.where((item) {
//       final date = item["date"] as DateTime;
//       return date.year == _selectedDate!.year &&
//           date.month == _selectedDate!.month &&
//           date.day == _selectedDate!.day;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredData = _getFilteredSlots();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F1EB),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1B4332),
//         elevation: 0,
//         title: const Text(
//           "My Availability Slots",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_today),
//             onPressed: _pickDate,
//             tooltip: "Select Date",
//           ),
//         ],
//       ),

//       /// If no date selected → show instruction
//       body: _selectedDate == null
//           ? const Center(
//               child: Text(
//                 "Please select a date from the calendar",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey,
//                 ),
//               ),
//             )

//           /// If selected but no slots
//           : filteredData.isEmpty
//               ? _buildEmptyState()

//               /// If slots exist
//               : ListView.builder(
//                   padding: const EdgeInsets.all(20),
//                   itemCount: filteredData.length,
//                   itemBuilder: (context, index) {
//                     final item = filteredData[index];
//                     final date = item["date"] as DateTime;
//                     final slots =
//                         List<Map<String, TimeOfDay>>.from(item["slots"]);

//                     return _buildDateCard(context, date, slots);
//                   },
//                 ),
//     );
//   }

//   /// Popup Calendar Picker
//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//       lastDate: DateTime(2027),
//     );

//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   Widget _buildEmptyState() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.event_busy, size: 60, color: Colors.grey),
//           SizedBox(height: 16),
//           Text(
//             "No Availability Added For This Date",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateCard(
//       BuildContext context, DateTime date, List<Map<String, TimeOfDay>> slots) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Date Header
//           Row(
//             children: [
//               const Icon(
//                 Icons.calendar_today,
//                 size: 18,
//                 color: Color(0xFF1B4332),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 "${date.day}/${date.month}/${date.year}",
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1B4332),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           const Divider(),
//           const SizedBox(height: 10),

//           /// Slots
//           ...slots.map((slot) {
//             return Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 14, vertical: 12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE9F5EF),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.access_time,
//                     size: 18,
//                     color: Color(0xFF1B4332),
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     "${slot["start"]!.format(context)}  -  ${slot["end"]!.format(context)}",
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1B4332),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'slot_storage.dart';

class SlotsPage extends StatefulWidget {
  const SlotsPage({super.key});

  @override
  State<SlotsPage> createState() => _SlotsPageState();
}

class _SlotsPageState extends State<SlotsPage> {
  /// ✅ Default selected date = Today
  DateTime _selectedDate = DateTime.now();

  /// Get slots for selected date
  List<Map<String, dynamic>> _getFilteredSlots() {
    return SlotStorage.allSlots.where((item) {
      final date = item["date"] as DateTime;
      return date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _getFilteredSlots();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        elevation: 0,

        // Make all icons (back arrow, etc.) white
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        // Disable default back button text
        automaticallyImplyLeading: false,

        // Custom white back arrow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // only arrow, no text
          onPressed: () => Navigator.of(context).pop(),
        ),

        title: Text(
          "Slots - ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        /// ✅ Premium Styled Calendar Icon
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: _pickDate,
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Color(0xFF1B4332),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: filteredData.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          final item = filteredData[index];
          final date = item["date"] as DateTime;
          final slots =
          List<Map<String, TimeOfDay>>.from(item["slots"]);

          return _buildDateCard(context, date, slots);
        },
      ),
    );
  }

  /// ✅ Premium Styled Popup Calendar
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1B4332),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1B4332),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No Availability Added For This Date",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(
      BuildContext context,
      DateTime date,
      List<Map<String, TimeOfDay>> slots,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Date Header
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 18,
                color: Color(0xFF1B4332),
              ),
              const SizedBox(width: 10),
              Text(
                "${date.day}/${date.month}/${date.year}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4332),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 10),

          /// Slots
          ...slots.map((slot) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F5EF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 18,
                    color: Color(0xFF1B4332),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${slot["start"]!.format(context)} - ${slot["end"]!.format(context)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B4332),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}