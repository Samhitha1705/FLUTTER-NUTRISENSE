import 'package:flutter/material.dart';

class SlotStorage {
  static List<Map<String, dynamic>> allSlots = [];

  static void addSlots(
      DateTime date, List<Map<String, TimeOfDay>> slots) {
    allSlots.add({
      "date": date,
      "slots": List.from(slots),
    });
  }
}