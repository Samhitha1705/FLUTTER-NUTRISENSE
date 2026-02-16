import 'package:flutter/material.dart';
import 'wishlist_storage.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {

  void removeItem(int index) {
    setState(() {
      globalWishlist.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: globalWishlist.isEmpty
          ? const Center(child: Text("Wishlist is empty"))
          : ListView.builder(
        itemCount: globalWishlist.length,
        itemBuilder: (context, index) {
          final item = globalWishlist[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(item.image, width: 60),
              title: Text(item.title),
              subtitle: Text("₹${item.price}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => removeItem(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
