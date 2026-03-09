import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:my_app/notification_page.dart';
import 'package:my_app/statefull.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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

  void openCheckout() {
    print("Inside pay now button");

    var options = {
      'key': 'rzp_test_RTzZoniisim7KO',
      'amount': int.parse(widget.orderItemCost) * 100,
      'name': 'Nutrition App',
      'description': 'Consultation Payment',
      'prefill': {'contact': '9876543210', 'email': 'test@gmail.com'}
    };

    _razorpay.open(options);
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Success ${response.paymentId}");
    print("Payment Successfully proceed to move");
    setState(() {
      Get.to(NotificationPage());
    });
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed ${response.message}");
    print("Payment Failed, Please come back");
    setState(() {
      Get.to(StatefulDashboard());
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
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
