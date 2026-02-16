class CartItem {
  final String title;
  final String image;
  final double price;
  final String category;
  int quantity;

  CartItem({
    required this.title,
    required this.image,
    required this.price,
    required this.category,
    this.quantity = 1,
  });
}
