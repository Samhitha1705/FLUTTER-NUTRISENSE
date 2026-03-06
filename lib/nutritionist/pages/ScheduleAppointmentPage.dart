// import 'package:flutter/material.dart';

// class ScheduleAppointmentPage extends StatefulWidget {
//   const ScheduleAppointmentPage({super.key});

//   @override
//   State<ScheduleAppointmentPage> createState() =>
//       _ScheduleAppointmentPageState();
// }

// class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
//   DateTime _selectedDate = DateTime.now();
//   String? _selectedTime;

//   final List<String> _timeSlots = [
//     "09:00 AM",
//     "10:00 AM",
//     "11:00 AM",
//     "12:00 PM",
//     "02:00 PM",
//     "03:00 PM",
//     "04:00 PM",
//     "05:00 PM",
//   ];

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2027),
//     );

//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _selectedTime = null;
//       });
//     }
//   }

//   void _confirmBooking() {
//     if (_selectedTime == null) return;

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Appointment Confirmed"),
//         content: Text(
//             "Booked on ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} at $_selectedTime"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             child: const Text("OK"),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F1EB),
//       appBar: AppBar(
//   backgroundColor: const Color(0xFF1B4332),
//   title: const Text(
//     "Schedule Appointment",
//     style: TextStyle(
//       color: Colors.white,
//     ),
//   ),
// ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Select Date",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             GestureDetector(
//               onTap: _pickDate,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                     const Icon(Icons.calendar_today),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             const Text(
//               "Available Time Slots",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               children: _timeSlots.map((time) {
//                 final selected = _selectedTime == time;
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _selectedTime = time;
//                     });
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 18, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: selected
//                           ? const Color(0xFF1B4332)
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: const Color(0xFF1B4332).withOpacity(0.4)),
//                     ),
//                     child: Text(
//                       time,
//                       style: TextStyle(
//                         color: selected ? Colors.white : Colors.black87,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _selectedTime == null ? null : _confirmBooking,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1B4332),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: const Text(
//                   "Confirm Appointment",
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//

// import 'package:flutter/material.dart';
// import 'slot_storage.dart';

// class ScheduleAppointmentPage extends StatefulWidget {
//   const ScheduleAppointmentPage({super.key});

//   @override
//   State<ScheduleAppointmentPage> createState() =>
//       _ScheduleAppointmentPageState();
// }

// class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
//   DateTime _selectedDate = DateTime.now();

//   // List of slots
//   List<Map<String, TimeOfDay>> _timeSlots = [];

//   // Temporary start & end before adding slot
//   TimeOfDay? _tempStartTime;
//   TimeOfDay? _tempEndTime;

//   // Pick Date
//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2027),
//     );

//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _timeSlots.clear();
//         _tempStartTime = null;
//         _tempEndTime = null;
//       });
//     }
//   }

//   // Pick Start Time
//   Future<void> _pickStartTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (picked != null) {
//       setState(() {
//         _tempStartTime = picked;

//         // Reset end time if invalid
//         if (_tempEndTime != null) {
//           final startMinutes = picked.hour * 60 + picked.minute;
//           final endMinutes =
//               _tempEndTime!.hour * 60 + _tempEndTime!.minute;

//           if (endMinutes <= startMinutes) {
//             _tempEndTime = null;
//           }
//         }
//       });
//     }
//   }

//   // Pick End Time
//   Future<void> _pickEndTime() async {
//     if (_tempStartTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select start time first")),
//       );
//       return;
//     }

//     final picked = await showTimePicker(
//       context: context,
//       initialTime: _tempStartTime!,
//     );

//     if (picked != null) {
//       setState(() {
//         _tempEndTime = picked;
//       });
//     }
//   }

//   // Add Slot
//   void _addTimeSlot() {
//     if (_tempStartTime == null || _tempEndTime == null) return;

//     final startMinutes =
//         _tempStartTime!.hour * 60 + _tempStartTime!.minute;
//     final endMinutes =
//         _tempEndTime!.hour * 60 + _tempEndTime!.minute;

//     if (endMinutes <= startMinutes) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("End time must be after start time")),
//       );
//       return;
//     }

//     // Prevent overlapping
//     for (var slot in _timeSlots) {
//       final existingStart =
//           slot["start"]!.hour * 60 + slot["start"]!.minute;
//       final existingEnd =
//           slot["end"]!.hour * 60 + slot["end"]!.minute;

//       if (startMinutes < existingEnd &&
//           endMinutes > existingStart) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text("Time slot overlaps existing slot")),
//         );
//         return;
//       }
//     }

//     setState(() {
//       _timeSlots.add({
//         "start": _tempStartTime!,
//         "end": _tempEndTime!,
//       });

//       _tempStartTime = null;
//       _tempEndTime = null;
//     });
//   }
//   void _confirmBooking() {
//   if (_timeSlots.isEmpty) return;

//   // Save slots globally
//   SlotStorage.addSlots(_selectedDate, _timeSlots);

//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text("Appointment Added to My Slots")),
//   );

//   setState(() {
//     _timeSlots.clear();
//     _tempStartTime = null;
//     _tempEndTime = null;
//   });

//   Navigator.pop(context);
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F1EB),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1B4332),
//         elevation: 0,
//   iconTheme: const IconThemeData(
//     color: Colors.white, // <-- This makes the back arrow white
//   ),
//         title: const Text(
//           "Schedule Appointment",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Select Date",
//               style: TextStyle(
//                   fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             GestureDetector(
//               onTap: _pickDate,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 16, vertical: 14),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border:
//                       Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: Row(
//                   mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
//                       style:
//                           const TextStyle(fontSize: 15),
//                     ),
//                     const Icon(Icons.calendar_today),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             const Text(
//               "Add Time Slot",
//               style: TextStyle(
//                   fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             GestureDetector(
//               onTap: _pickStartTime,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 18, vertical: 14),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border:
//                       Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: Row(
//                   mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       _tempStartTime == null
//                           ? "Select Start Time"
//                           : "Start: ${_tempStartTime!.format(context)}",
//                     ),
//                     const Icon(Icons.access_time),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 12),

//             GestureDetector(
//               onTap: _pickEndTime,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 18, vertical: 14),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border:
//                       Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: Row(
//                   mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       _tempEndTime == null
//                           ? "Select End Time"
//                           : "End: ${_tempEndTime!.format(context)}",
//                     ),
//                     const Icon(Icons.access_time),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 15),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: (_tempStartTime != null &&
//                         _tempEndTime != null)
//                     ? _addTimeSlot
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       const Color(0xFF1B4332),
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 14),
//                 ),
//                 child: Text(
//   "Add Slot",
//   style: TextStyle(
//     color: Colors.white,
//   ),
// ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             const Text(
//               "Added Slots",
//               style: TextStyle(
//                   fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             Expanded(
//               child: ListView.builder(
//                 itemCount: _timeSlots.length,
//                 itemBuilder: (context, index) {
//                   final slot = _timeSlots[index];

//                   return Container(
//                     margin:
//                         const EdgeInsets.only(bottom: 8),
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                           BorderRadius.circular(10),
//                       border: Border.all(
//                           color:
//                               Colors.grey.shade300),
//                     ),
//                     child: Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment
//                               .spaceBetween,
//                       children: [
//                         Text(
//                           "${slot["start"]!.format(context)} - ${slot["end"]!.format(context)}",
//                         ),
//                         IconButton(
//                           icon: const Icon(
//                               Icons.delete,
//                               color: Colors.red),
//                           onPressed: () {
//                             setState(() {
//                               _timeSlots
//                                   .removeAt(index);
//                             });
//                           },
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _timeSlots.isNotEmpty
//                     ? _confirmBooking
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       const Color(0xFF1B4332),
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 16),
//                 ),
//                 child: const Text("Confirm Appointment",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'slot_storage.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  const ScheduleAppointmentPage({super.key});

  @override
  State<ScheduleAppointmentPage> createState() =>
      _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  DateTime _selectedDate = DateTime.now();

  // List of slots
  List<Map<String, TimeOfDay>> _timeSlots = [];

  // Temporary start & end before adding slot
  TimeOfDay? _tempStartTime;
  TimeOfDay? _tempEndTime;

  // ✅ Track if booking was confirmed
  bool _bookingConfirmed = false;

  // Pick Date
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
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
        _timeSlots.clear();
        _tempStartTime = null;
        _tempEndTime = null;
        _bookingConfirmed = false; // Reset success card
      });
    }
  }

  // Pick Start Time
  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _tempStartTime = picked;

        if (_tempEndTime != null) {
          final startMinutes = picked.hour * 60 + picked.minute;
          final endMinutes = _tempEndTime!.hour * 60 + _tempEndTime!.minute;

          if (endMinutes <= startMinutes) {
            _tempEndTime = null;
          }
        }
      });
    }
  }

  // Pick End Time
  Future<void> _pickEndTime() async {
    if (_tempStartTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select start time first")),
      );
      return;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: _tempStartTime!,
    );

    if (picked != null) {
      setState(() {
        _tempEndTime = picked;
      });
    }
  }

  // Add Slot
  void _addTimeSlot() {
    if (_tempStartTime == null || _tempEndTime == null) return;

    final startMinutes = _tempStartTime!.hour * 60 + _tempStartTime!.minute;
    final endMinutes = _tempEndTime!.hour * 60 + _tempEndTime!.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End time must be after start time")),
      );
      return;
    }

    // Prevent overlapping
    for (var slot in _timeSlots) {
      final existingStart = slot["start"]!.hour * 60 + slot["start"]!.minute;
      final existingEnd = slot["end"]!.hour * 60 + slot["end"]!.minute;

      if (startMinutes < existingEnd && endMinutes > existingStart) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Time slot overlaps existing slot")),
        );
        return;
      }
    }

    setState(() {
      _timeSlots.add({
        "start": _tempStartTime!,
        "end": _tempEndTime!,
      });
      _tempStartTime = null;
      _tempEndTime = null;
    });
  }

  // Confirm Booking
  void _confirmBooking() {
    if (_timeSlots.isEmpty) return;

    // Save slots globally
    SlotStorage.addSlots(_selectedDate, _timeSlots);

    // ✅ Show success card
    setState(() {
      _bookingConfirmed = true;
      _timeSlots.clear();
      _tempStartTime = null;
      _tempEndTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Schedule Appointment",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Date",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                            style: const TextStyle(fontSize: 15)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                const Text("Add Time Slot",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // Start Time
                GestureDetector(
                  onTap: _pickStartTime,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_tempStartTime == null
                            ? "Select Start Time"
                            : "Start: ${_tempStartTime!.format(context)}"),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // End Time
                GestureDetector(
                  onTap: _pickEndTime,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_tempEndTime == null
                            ? "Select End Time"
                            : "End: ${_tempEndTime!.format(context)}"),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_tempStartTime != null && _tempEndTime != null)
                        ? _addTimeSlot
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4332),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Add Slot",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Text("Added Slots",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    itemCount: _timeSlots.length,
                    itemBuilder: (context, index) {
                      final slot = _timeSlots[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${slot["start"]!.format(context)} - ${slot["end"]!.format(context)}"),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _timeSlots.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _timeSlots.isNotEmpty ? _confirmBooking : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4332),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Confirm Appointment",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Success Card Overlay
          if (_bookingConfirmed)
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 50,
                      color: Color(0xFF1B4332), // Greenish check
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Appointment Added Successfully!",
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B4332),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          // ✅ Navigate to Dashboard
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}