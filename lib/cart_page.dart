import 'package:flutter/material.dart';
import 'cart_storage.dart';
import 'address_book_page.dart';
import 'payment/payment_gateway.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String? selectedAddress;

  double get totalPrice {
    double total = 0;
    for (var item in globalCart) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void increaseQty(int index) {
    setState(() {
      globalCart[index].quantity++;
    });
  }

  void decreaseQty(int index) {
    setState(() {
      if (globalCart[index].quantity > 1) {
        globalCart[index].quantity--;
      } else {
        globalCart.removeAt(index);

        if (globalCart.isEmpty) {
          Navigator.pop(context);
        }
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      globalCart.removeAt(index);

      if (globalCart.isEmpty) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: globalCart.isEmpty
          ? const Center(child: Text("Cart is Empty"))
          : Column(
              children: [
                /// ADDRESS SECTION
                Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      selectedAddress ?? "Select Delivery Address",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddressBookPage(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          selectedAddress = result;
                        });
                      }
                    },
                  ),
                ),

                /// CART ITEMS
                Expanded(
                  child: ListView.builder(
                    itemCount: globalCart.length,
                    itemBuilder: (context, index) {
                      final item = globalCart[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          leading: Image.network(
                            item.image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item.title),
                          subtitle: Text(
                            "₹${item.price}  x  ${item.quantity}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => decreaseQty(index),
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                item.quantity.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () => increaseQty(index),
                                icon: const Icon(Icons.add),
                              ),
                              IconButton(
                                onPressed: () => removeItem(index),
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// TOTAL + PLACE ORDER
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total", style: TextStyle(fontSize: 18)),
                            Text(
                              "₹${totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white, // ✅ White text
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: selectedAddress == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => razorPay(
                                        // title: "Cart Order",
                                        // image: globalCart.isNotEmpty
                                        //     ? globalCart.first.image
                                        //     : "",
                                        orderItemCost: totalPrice.toString(),
                                        // category: "Cart",
                                      ),
                                    ),
                                  );
                                },
                          child: const Text(
                            "Place Order",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
