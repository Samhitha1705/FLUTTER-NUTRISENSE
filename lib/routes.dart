import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'package:my_app/registrationPage.dart';
import 'package:my_app/splashscreen.dart';
import 'package:my_app/statefull.dart';

var onGenerateRoute = (RouteSettings settings){
  if(settings.name == "/"){
    return MaterialPageRoute(builder: (builder)=> MyApp(FirstName: ""));
  }else if(settings.name == "/dasboard"){
    return MaterialPageRoute(builder: (builder)=> maniPage(phone: ""));
  }else if(settings.name == "/LoginScreen"){
    return MaterialPageRoute(builder:(builder)=> MyApp(FirstName: ""));
  }else{
    return MaterialPageRoute(builder: (builder)=> Registrationpage());
  }
};