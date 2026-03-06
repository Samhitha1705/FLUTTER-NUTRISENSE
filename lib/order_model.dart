class OrderModel {
  final String title;
  final String image;
  final double price;
  final String category;
  final DateTime time;
  String status;   // mutable to allow updates

  OrderModel({
    required this.title,
    required this.image,
    required this.price,
    required this.category,
    required this.time,
    required this.status,
  });
}