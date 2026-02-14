import 'package:flutter/material.dart';

class AddressBookPage extends StatelessWidget {
  const AddressBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Address Book")),
      body: const Center(
        child: Text(
          "No addresses added yet",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
