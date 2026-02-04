import 'package:flutter/material.dart';

class reviewsPage extends StatelessWidget {
  const reviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Reviews"),
      ),
      body: PageView(
        children: [
          myReviewContainer(1),
          myReviewContainer(2),
          myReviewContainer(3)
        ],
      ),
    );
  }

Widget myReviewContainer(int index){
  return Center(child: Text("Review $index", style: TextStyle(fontSize: 30),));
}
}