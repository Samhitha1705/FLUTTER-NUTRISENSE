import 'package:flutter/material.dart';
import 'package:my_app/payment/payment_gateway.dart';
// import 'package:my_app/appointment.dart';

class Nutrionistprofile extends StatelessWidget {
  const Nutrionistprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Nutrionist Profile")),
        body: Column(
          children: [
            Text("Name:"),
            Text("Experience"),
            Text("Address"),
            Text("Phone:+91"),
            Text("Availability Timings IST"),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => razorPay(
                            orderItemCost: "300",
                          )));
                },
                style: TextButton.styleFrom(backgroundColor: Colors.lightBlue),
                child: Text("10:00 AM", style: TextStyle())),
            TextButton(onPressed: () {}, child: Text("12:00 PM")),
            TextButton(onPressed: () {}, child: Text("04:00 PM")),
            TextButton(onPressed: () {}, child: Text("06:00 PM")),
          ],
        ));
  }
}
