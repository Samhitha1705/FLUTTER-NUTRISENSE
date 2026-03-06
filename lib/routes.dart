import 'package:flutter/material.dart';
import 'aboutFood.dart';
import 'payment_gateway.dart';
import 'my_orders.dart';
import 'registrationPage.dart';
import 'statefull.dart';
import 'expandWidget.dart';
import 'main.dart';
import 'address_book_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final args = settings.arguments as Map<String, dynamic>?;

  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (_) => const SplashScreen());

    case "/dashboard":
      return MaterialPageRoute(
        builder: (_) => StatefulDashboard(
          token: args?["token"] ?? "",
        ),
      );

    case "/register":
      return MaterialPageRoute(builder: (_) => const Registrationpage());

    case "/aboutFood":
      return MaterialPageRoute(
        builder: (_) => Aboutfood(
          title: args?["title"] ?? "",
          image: args?["image"] ?? "",
          description: args?["description"] ?? "",
          price: args?["price"] ?? "",
          category: args?["category"] ?? "", token: '',
        ),
      );

    case "/payment":
      return MaterialPageRoute(
        builder: (_) => PaymentGateway(
          title: args?["title"] ?? "",
          image: args?["image"] ?? "",
          orderItemCost: args?["price"] ?? "",
          category: args?["category"] ?? "", token: '',
        ),
      );

    case "/orders":
      return MaterialPageRoute(
        builder: (_) => MyOrdersPage(
          token: args?["token"] ?? "",
        ),
      );

    case "/addressBook":
      return MaterialPageRoute(
        builder: (_) => AddressBookPage(
          token: args?["token"] ?? "",
        ),
      );

    case "/profile":
      return MaterialPageRoute(
        builder: (_) => ExpandWidget(
          token: args?["token"] ?? "",
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text("Route not found")),
        ),
      );
  }
}