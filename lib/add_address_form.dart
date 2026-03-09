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
  final _formKey = GlobalKey<FormState>();

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
    // Validate the form before saving
    if (_formKey.currentState!.validate()) {
      final address = AddressModel(
        id: widget.address?.id,
        line1: line1Controller.text.trim(),
        line2: line2Controller.text.trim(),
        city: cityController.text.trim(),
        postCode: postCodeController.text.trim(),
        defaultAddress: defaultAddress,
      );

      widget.onSave(address);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Add Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: line1Controller,
                decoration: const InputDecoration(
                    labelText: "Address Line 1", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Address Line 1 is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: line2Controller,
                decoration: const InputDecoration(
                    labelText: "Address Line 2", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                    labelText: "City", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "City is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: postCodeController,
                decoration: const InputDecoration(
                    labelText: "Post Code", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Post Code is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

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

              Center(
                child: ElevatedButton(
                  onPressed: save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    "Save Address",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}