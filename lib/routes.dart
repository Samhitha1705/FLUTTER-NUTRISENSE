import 'package:flutter/material.dart';
import 'aboutFood.dart';
import 'payment/payment_gateway.dart';
import 'my_orders.dart';
import 'registrationPage.dart';
import 'statefull.dart';
import 'main.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      );

    case "/dashboard":
      return MaterialPageRoute(
        builder: (_) => const StatefulDashboard(),
      );

    case "/register":
      return MaterialPageRoute(
        builder: (_) => const Registrationpage(),
      );

    case "/aboutFood":
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => Aboutfood(
          title: args["title"],
          image: args["image"],
          description: args["description"],
          price: args["price"],
          category: args["category"],
        ),
      );

    case "/payment":
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => razorPay(
          // title: args["title"],
          // image: args["image"],
          orderItemCost: args["price"],
          // category: args["category"],
        ),
      );

    case "/orders":
      return MaterialPageRoute(
        builder: (_) => const MyOrdersPage(),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text("Route not found")),
        ),
      );
  }
}
