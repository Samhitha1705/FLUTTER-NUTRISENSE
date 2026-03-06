import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'order_storage.dart';
import 'order_model.dart';
import 'my_orders.dart';

class PaymentGateway extends StatefulWidget {
  final String title;
  final String image;
  final String orderItemCost;
  final String category; // "Subscription" OR "Food"
  final String token; // ✅ add token

  const PaymentGateway({
    super.key,
    required this.title,
    required this.image,
    required this.orderItemCost,
    required this.category,
    required this.token, // ✅ required
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
      'description': widget.category == "Subscription"
          ? "Subscription Upgrade"
          : "Food Order",
    };

    _razorpay.open(options);
  }

  // ================= SUCCESS =================
  void _handleSuccess(PaymentSuccessResponse response) {
    if (widget.category == "Subscription") {
      Navigator.pop(context, true);
      return;
    }

    OrderModel newOrder = OrderModel(
      title: widget.title,
      image: widget.image,
      price: double.parse(widget.orderItemCost),
      category: widget.category,
      time: DateTime.now(),
      status: "Order Placed",
    );

    globalOrders.insert(0, newOrder);

    // Auto status updates
    Future.delayed(const Duration(seconds: 5), () {
      newOrder.status = "Preparing";
    });

    Future.delayed(const Duration(seconds: 10), () {
      newOrder.status = "Out for Delivery";
    });

    Future.delayed(const Duration(seconds: 15), () {
      newOrder.status = "Delivered";
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => MyOrdersPage(token: widget.token)), // ✅ pass token
    );
  }

  // ================= ERROR =================
  void _handleError(PaymentFailureResponse response) {
    if (widget.category == "Subscription") {
      Navigator.pop(context, false);
      return;
    }

    globalOrders.insert(
      0,
      OrderModel(
        title: widget.title,
        image: widget.image,
        price: double.parse(widget.orderItemCost),
        category: widget.category,
        time: DateTime.now(),
        status: "Payment Failed",
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => MyOrdersPage(token: widget.token)), // ✅ pass token
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