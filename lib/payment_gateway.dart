import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'order_storage.dart';
import 'order_model.dart';
import 'my_orders.dart';

class PaymentGateway extends StatefulWidget {
  final String title;
  final String image;
  final String orderItemCost;
  final String category;

  const PaymentGateway({
    super.key,
    required this.title,
    required this.image,
    required this.orderItemCost,
    required this.category,
  });

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      openCheckout();
    });
  }

  void openCheckout() {
    int amount = int.tryParse(widget.orderItemCost) ?? 100;

    var options = {
      'key': 'rzp_test_RTzZoniisim7KO',
      'amount': amount * 100,
      'name': widget.title,
      'description': 'Food Order',
    };

    _razorpay.open(options);
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    globalOrders.insert(
      0,
      OrderModel(
        title: widget.title,
        image: widget.image,
        price: double.parse(widget.orderItemCost),
        category: widget.category,
        time: DateTime.now(),
        status: "Success",
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyOrdersPage()),
    );
  }

  void _handleError(PaymentFailureResponse response) {
    globalOrders.insert(
      0,
      OrderModel(
        title: widget.title,
        image: widget.image,
        price: double.parse(widget.orderItemCost),
        category: widget.category,
        time: DateTime.now(),
        status: "Failed",
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyOrdersPage()),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
