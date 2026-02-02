import 'package:flutter/material.dart';

class homePageScreen extends StatelessWidget {
  const homePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body:ListView(
      //   padding: EdgeInsets.all(8),
      //   reverse: false,
      //   children: [
      //     myContainer(index: 1, color: Colors.white),
      //     myContainer(index: 2, color: Colors.pink),
      //     myContainer(index: 3, color: Colors.green)
           
      //   ],
      // )
      body:ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: 10,
        itemBuilder:(context, index)
        
      {
        return myContainer(index: index, color: Colors.green);
        
      } )
      );
  }

  Widget myContainer({required int index, required Color color}){
    return Container(
      color: color,
      width: double.infinity,
      height:300,
      child: Center(
      child:Text("$index",style:TextStyle(fontSize: 30))
        ),
    );
    
  }
}