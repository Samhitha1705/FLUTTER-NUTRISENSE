import 'package:flutter/material.dart';
import 'package:my_app/main.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
    void initState() {
      super.initState();
      timeFunction();
        
    }    
    timeFunction()async{
      await Future.delayed(Duration(milliseconds: 1800),(){});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(FirstName: ""),
        ),
        
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Container(
          child: Text(
            "Splash-Screen", style:TextStyle(
              fontSize: 40,color:Colors.blue))))
    );
    
  }
}