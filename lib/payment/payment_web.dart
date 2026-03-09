import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:my_app/Nutrionistprofile.dart';
import 'package:my_app/notification_page.dart';
import 'package:my_app/statefull.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get/get_core/src/get_main.dart' show Get;

class razorPay extends StatefulWidget {
  final String orderItemCost;

  const razorPay({super.key, required this.orderItemCost});

  @override
  State<razorPay> createState() => _razorPayState();
}

class _razorPayState extends State<razorPay> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Success ${response.paymentId}");
    print("Payment Successfully through Web proceed to move");
    setState(() {
      Get.to(NotificationPage());
    });
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed ${response.message}");
    print("Payment Failed through web, Please come back");
    setState(() {
      Get.to(StatefulDashboard());
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout() {
    js.context.callMethod('eval', [
      """
      var options = {
        "key": "rzp_test_RTzZoniisim7KO",
        "amount": ${int.parse(widget.orderItemCost) * 100},
        "name": "Nutrition App",
        "description": "Consultation Payment",
        "handler": function (response){
          alert("Payment Success: " + response.razorpay_payment_id);
        }
      };

      var rzp1 = new Razorpay(options);
      rzp1.open();
    """
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: openCheckout,
          child: Text("Pay Now"),
        ),
      ),
    );
  }
}
