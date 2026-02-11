import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class razorPay extends StatefulWidget {
  final String orderItemCost;

  const razorPay({super.key, this.orderItemCost=""});
  
  @override
  State<razorPay> createState() => _razorPayState();
}

class _razorPayState extends State<razorPay> {

  var _razorpay = Razorpay();
  
  Map<String ,dynamic> options ={};

  @override
    void initState() {
      super.initState();
      options = {
        'key': 'rzp_test_RTzZoniisim7KO',
        'amount':"mai",
        'name': 'MTL Corporation.',
        'description': 'Nutrion Organic Foods',
        'prefill': {
          'contact': '9959214209',
          'email': 'test@gmail.com'
        }
      };
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      title: Text("Payment Details"),
     ),
     body: Column(children: [
        ElevatedButton(onPressed: (){
          _razorpay.open(options);
          print("hello");
        }, child: Text("Complete Payment"))
     ],),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
  // Do something when payment succeeds
    print("_handlePaymentSuccess");
    Fluttertoast.showToast(msg: "__handlePaymentSuccess");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("_handlePaymentError");
    Fluttertoast.showToast(msg: "_handlePaymentError");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print("_handleExternalWallet");
    Fluttertoast.showToast(msg:"_handleExternalWallet");
  }
}