import 'package:flutter/material.dart';
import 'address_model.dart';

class AddAddressForm extends StatefulWidget {
  final AddressModel? existingAddress;
  final Function(AddressModel) onSave;

  const AddAddressForm({
    super.key,
    this.existingAddress,
    required this.onSave,
  });

  @override
  State<AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  final houseController = TextEditingController();
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final receiverController = TextEditingController();
  final phoneController = TextEditingController();

  String countryCode = "+91";

  @override
  void initState() {
    super.initState();

    if (widget.existingAddress != null) {
      houseController.text = widget.existingAddress!.houseNo;
      areaController.text = widget.existingAddress!.area;
      cityController.text = widget.existingAddress!.city;
      stateController.text = widget.existingAddress!.state;
      pincodeController.text = widget.existingAddress!.pincode;
      receiverController.text = widget.existingAddress!.receiverName;
      phoneController.text = widget.existingAddress!.receiverPhone;
      countryCode = widget.existingAddress!.countryCode;
    }
  }

  void save() {
    final address = AddressModel(
      houseNo: houseController.text,
      area: areaController.text,
      city: cityController.text,
      state: stateController.text,
      pincode: pincodeController.text,
      receiverName: receiverController.text,
      receiverPhone: phoneController.text,
      countryCode: countryCode,
      isDefault: widget.existingAddress?.isDefault ?? false,
    );

    widget.onSave(address);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Address",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: houseController,
              decoration: const InputDecoration(labelText: "House No"),
            ),
            TextField(
              controller: areaController,
              decoration: const InputDecoration(labelText: "Area"),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: "City"),
            ),
            TextField(
              controller: stateController,
              decoration: const InputDecoration(labelText: "State"),
            ),
            TextField(
              controller: pincodeController,
              decoration: const InputDecoration(labelText: "Pincode"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: receiverController,
              decoration: const InputDecoration(labelText: "Receiver Name"),
            ),

            Row(
              children: [
                DropdownButton<String>(
                  value: countryCode,
                  items: const [
                    DropdownMenuItem(value: "+91", child: Text("+91")),
                    DropdownMenuItem(value: "+1", child: Text("+1")),
                    DropdownMenuItem(value: "+44", child: Text("+44")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      countryCode = value!;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: "Phone"),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                "Save Address",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}