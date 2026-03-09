import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  final String baseUrl = "http://192.168.100.162:8080";

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// GET ADDRESSES
  Future<void> fetchAddresses() async {

    String? token = await getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/customers/addresses"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      setState(() {
        addressList =
            data.map((e) => AddressModel.fromJson(e)).toList();
      });
    }
  }

  /// ADD ADDRESS
  Future<void> addAddress(AddressModel address) async {

    String? token = await getToken();

    await http.post(
      Uri.parse("$baseUrl/api/v1/customers/addresses"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(address.toJson()),
    );

    fetchAddresses();
  }

  /// UPDATE ADDRESS
  Future<void> updateAddress(AddressModel address) async {

    String? token = await getToken();

    await http.put(
      Uri.parse("$baseUrl/api/v1/customers/addresses/${address.id}"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(address.toJson()),
    );

    fetchAddresses();
  }

  /// DELETE ADDRESS
  Future<void> deleteAddress(int id) async {

    String? token = await getToken();

    await http.delete(
      Uri.parse("$baseUrl/api/v1/customers/addresses/$id"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    fetchAddresses();
  }

  void openForm({AddressModel? address}) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddAddressForm(
        address: address,
        onSave: (newAddress) {

          if (address == null) {
            addAddress(newAddress);
          } else {
            updateAddress(newAddress);
          }
        },
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
        child: const Icon(Icons.add),
        onPressed: () => openForm(),
      ),

      body: addressList.isEmpty
          ? const Center(child: Text("No addresses added"))
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
                color: address.defaultAddress
                    ? Colors.green
                    : Colors.red,
              ),

              title: Text(address.line1),

              subtitle: Text(
                "${address.line2}\n${address.city} - ${address.postCode}",
              ),

              isThreeLine: true,

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // EDIT BUTTON
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: Colors.blue),
                    onPressed: () => openForm(address: address),
                  ),

                  // DELETE BUTTON WITH CONFIRMATION
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Delete Address"),
                          content: const Text(
                              "Are you sure you want to delete this address?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text("Yes"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        deleteAddress(address.id!);
                      }
                    },
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