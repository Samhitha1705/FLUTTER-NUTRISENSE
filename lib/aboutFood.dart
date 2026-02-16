import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'cart_model.dart';
import 'cart_storage.dart';
import 'cart_page.dart';
import 'wishlist_model.dart';
import 'wishlist_storage.dart';

class Aboutfood extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String price;
  final String category;

  const Aboutfood({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.category,
  });

  @override
  State<Aboutfood> createState() => _AboutfoodState();
}

class _AboutfoodState extends State<Aboutfood> {

  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    checkWishlist();
  }

  void checkWishlist() {
    isWishlisted = globalWishlist.any(
          (item) => item.title == widget.title,
    );
  }

  /// ADD TO CART (NO DUPLICATE)
  void addToCart() {
    int index = globalCart.indexWhere(
          (item) => item.title == widget.title,
    );

    if (index != -1) {
      globalCart[index].quantity++;
    } else {
      globalCart.add(
        CartItem(
          title: widget.title,
          image: widget.image,
          price: double.parse(widget.price),
          category: widget.category,
          quantity: 1,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to Cart")),
    );
  }

  /// TOGGLE WISHLIST
  void toggleWishlist() {
    setState(() {
      if (isWishlisted) {
        globalWishlist.removeWhere(
              (item) => item.title == widget.title,
        );
        isWishlisted = false;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Removed from Wishlist")),
        );
      } else {
        globalWishlist.add(
          WishlistModel(
            title: widget.title,
            image: widget.image,
            price: double.parse(widget.price),
          ),
        );
        isWishlisted = true;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added to Wishlist")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [

          /// WISHLIST HEART ICON
          IconButton(
            icon: Icon(
              isWishlisted
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: toggleWishlist,
          ),

          /// CART ICON
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// FOOD IMAGE
            CachedNetworkImage(
              imageUrl: widget.image,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 15),

            /// TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// PRICE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "₹${widget.price}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            /// BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  //color: Colors.white,
                  foregroundColor: Colors.white, // ✅ TEXT COLOR HERE

                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: addToCart,
                child: const Text("Add to Cart"),
              ),
            ),

            const SizedBox(height: 20),

            /// VIEW CART BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartPage(),
                    ),
                  );
                },
                child: const Text("Go to Cart"),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
