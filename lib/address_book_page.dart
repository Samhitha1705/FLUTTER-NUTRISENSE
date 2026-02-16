import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'address_model.dart';
import 'add_address_form.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  List<AddressModel> addressList = [];

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('addresses');

    if (data != null) {
      final List decoded = jsonDecode(data);
      addressList =
          decoded.map((e) => AddressModel.fromJson(e)).toList();
    }

    setState(() {});
  }

  Future<void> saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
    jsonEncode(addressList.map((e) => e.toJson()).toList());
    await prefs.setString('addresses', encoded);
  }

  // ADD OR EDIT ADDRESS
  void addOrEditAddress(AddressModel address, {int? index}) async {
    if (index == null) {
      if (addressList.isEmpty) {
        address.isDefault = true;
      }
      addressList.add(address);
    } else {
      address.isDefault = addressList[index].isDefault;
      addressList[index] = address;
    }

    await saveAddresses();
    setState(() {});
  }

  // DELETE ADDRESS
  void deleteAddress(int index) async {
    bool wasDefault = addressList[index].isDefault;

    addressList.removeAt(index);

    if (wasDefault && addressList.isNotEmpty) {
      addressList[0].isDefault = true;
    }

    await saveAddresses();
    setState(() {});
  }

  // ✅ SET DEFAULT
  Future<void> setDefault(int index) async {
    for (int i = 0; i < addressList.length; i++) {
      addressList[i].isDefault = false;
    }

    addressList[index].isDefault = true;

    await saveAddresses();
    setState(() {});
  }

  void openForm({AddressModel? address, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddAddressForm(
        existingAddress: address,
        onSave: (newAddress) =>
            addOrEditAddress(newAddress, index: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address Book"),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
      body: addressList.isEmpty
          ? const Center(child: Text("No addresses added yet"))
          : ListView.builder(
        itemCount: addressList.length,
        itemBuilder: (context, index) {
          final address = addressList[index];

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 8),
            child: ListTile(
              leading: Icon(
                Icons.location_on,
                color: address.isDefault
                    ? Colors.green
                    : Colors.red,
              ),
              title: Text(
                  "${address.houseNo}, ${address.area}"),
              subtitle: Text(
                  "${address.city}, ${address.state} - ${address.pincode}\n"
                      "Receiver: ${address.receiverName}\n"
                      "Phone: ${address.countryCode} ${address.receiverPhone}"),
              isThreeLine: true,

              // ✅ FIXED HERE (IMPORTANT)
              onTap: () async {
                await setDefault(index);

                String fullAddress =
                    "${address.houseNo}, ${address.area}, "
                    "${address.city}, ${address.state} - ${address.pincode}\n"
                    "Receiver: ${address.receiverName}\n"
                    "Phone: ${address.countryCode} ${address.receiverPhone}";

                Navigator.pop(context, fullAddress);
              },

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: Colors.blue),
                    onPressed: () => openForm(
                        address: address, index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.red),
                    onPressed: () =>
                        deleteAddress(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
