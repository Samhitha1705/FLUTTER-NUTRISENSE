import 'package:flutter/material.dart';

class reviewsPage extends StatelessWidget {

  PageController pageController = PageController();

  reviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Reviews"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.bounceIn);
      }, child:Icon(Icons.skip_next)),
      body: PageView(
        controller: pageController,
        children: [
          myReviewContainer(1),
          myReviewContainer(2),
          myReviewContainer(3)
        ],
      ),
    );
  }

Widget myReviewContainer(int index){
  return Center(child: Text("Review $index", style: TextStyle(fontSize: 30, color: Colors.blue, backgroundColor: Colors.amber)));
}
}