import 'package:flutter/material.dart';
import 'address_model.dart';

class AddAddressForm extends StatefulWidget {
  final AddressModel? address;
  final Function(AddressModel) onSave;

  const AddAddressForm({
    super.key,
    this.address,
    required this.onSave,
  });

  @override
  State<AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {

  final line1Controller = TextEditingController();
  final line2Controller = TextEditingController();
  final cityController = TextEditingController();
  final postCodeController = TextEditingController();

  bool defaultAddress = false;

  @override
  void initState() {
    super.initState();

    if (widget.address != null) {
      line1Controller.text = widget.address!.line1;
      line2Controller.text = widget.address!.line2;
      cityController.text = widget.address!.city;
      postCodeController.text = widget.address!.postCode;
      defaultAddress = widget.address!.defaultAddress;
    }
  }

  void save() {

    final address = AddressModel(
      id: widget.address?.id,
      line1: line1Controller.text,
      line2: line2Controller.text,
      city: cityController.text,
      postCode: postCodeController.text,
      defaultAddress: defaultAddress,
    );

    widget.onSave(address);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),

      child: SingleChildScrollView(
        child: Column(

          children: [

            const Text(
              "Add Address",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: line1Controller,
              decoration: const InputDecoration(labelText: "Address Line 1"),
            ),

            TextField(
              controller: line2Controller,
              decoration: const InputDecoration(labelText: "Address Line 2"),
            ),

            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: "City"),
            ),

            TextField(
              controller: postCodeController,
              decoration: const InputDecoration(labelText: "Post Code"),
            ),

            Row(
              children: [
                Checkbox(
                  value: defaultAddress,
                  onChanged: (v) {
                    setState(() {
                      defaultAddress = v!;
                    });
                  },
                ),
                const Text("Set as Default Address")
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                "Save Address",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}