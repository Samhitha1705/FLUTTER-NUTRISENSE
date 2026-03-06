import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressModel {
  int id;
  String houseNo;
  String area;
  String city;
  String state;
  String pincode;
  String receiverName;
  String receiverPhone;
  String countryCode;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.houseNo,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
    required this.receiverName,
    required this.receiverPhone,
    required this.countryCode,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      houseNo: json['houseNo'] ?? "",
      area: json['area'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      pincode: json['pincode'] ?? "",
      receiverName: json['receiverName'] ?? "",
      receiverPhone: json['receiverPhone'] ?? "",
      countryCode: json['countryCode'] ?? "+91",
      isDefault: json['isDefault'] ?? false,
    );
  }
}

class AddressBookPage extends StatefulWidget {
  final String token;
  const AddressBookPage({super.key, required this.token});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  List<AddressModel> addressList = [];

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    final response = await http.get(
      Uri.parse('http://192.168.100.162:8080/api/v1/customers/addresses'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        addressList = data.map((e) => AddressModel.fromJson(e)).toList();
      });
    } else {
      print("Error fetching addresses: ${response.statusCode}");
    }
  }

  Future<void> deleteAddress(int id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.100.162:8080/api/v1/customers/addresses/$id'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 204) {
      fetchAddresses();
    } else {
      print("Error deleting address: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Address Book"), backgroundColor: Colors.red),
      body: ListView.builder(
        itemCount: addressList.length,
        itemBuilder: (context, index) {
          final address = addressList[index];
          return ListTile(
            title: Text("${address.houseNo}, ${address.area}, ${address.city}"),
            subtitle: Text("${address.state} - ${address.pincode}\nReceiver: ${address.receiverName}\nPhone: ${address.countryCode} ${address.receiverPhone}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteAddress(address.id),
            ),
          );
        },
      ),
    );
  }
}