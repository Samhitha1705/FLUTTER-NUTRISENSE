import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/registrationPage.dart';
import 'package:my_app/statefull.dart';
// import 'splashscreen.dart';
void main() {
  runApp(MaterialApp
  (
    debugShowCheckedModeBanner: false,
    home: AnimatedSplashScreen(splash: Icons.cyclone,duration:3000,
    splashTransition: SplashTransition.rotationTransition,
    backgroundColor: Colors.blue, nextScreen: MyApp(FirstName: "",))
  ),
  );
}

class MyApp extends StatelessWidget {
  String FirstName;
  MyApp({super.key,required this.FirstName});
  
  @override
  Widget build(BuildContext context) {
    TextEditingController phoneTextEditingController = TextEditingController();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Food-Nutri-App"),
        centerTitle: true,
        // leading: Icon(Icons.home),
        // actions: [Icon(Icons.logout)],
      ),
      // body:Center(
        
      //   child:Container(
      //     height:180,
      //     width:180,
      //     margin:EdgeInsets.all(10),

      //     decoration: BoxDecoration(
      //       color:Colors.green,
      //       boxShadow: [BoxShadow(color:Colors.pink,spreadRadius: 1)],
      //       borderRadius: BorderRadius.circular(14),
      //       border: Border.all(
      //         color: Colors.black,width: 3,
      //       )
            
      //     ),
      //     child:Center(child: Text("hello",style:TextStyle(color:Colors.white,fontSize:40,fontWeight: FontWeight.bold ))),
      //   )
      // ),
      body:SingleChildScrollView(
        child: Column(
  
          children: [
            // Text(FirstName),
            // Container(
            //   width:100,
            //   height:100,
            //   color:Colors.red,

            // ),
            // ElevatedButton(onPressed: (){
             
              
            // }, child: Text("change color")),
            // Icon(Icons.favorite,size:40),
            // IconButton(onPressed: (){
            //   print("click camera icon");
            // }, icon: Icon(Icons.linked_camera)),
            // Text("click me"),
            // TextButton(onPressed: (){}, child: Text("Clickable here", style:TextStyle(color:Colors.red))),
          //         ElevatedButton(onPressed: (){},   style: ElevatedButton.styleFrom(backgroundColor: (Colors.yellow),
          // ),
          //         child: Text("Elevated", style:TextStyle(color:Colors.pink))),
            Image.asset("assets/images/food-image.png",fit: BoxFit.cover, height:250),
            SizedBox(height:30),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text("Enter phone Number")),
            Padding(
              padding: const EdgeInsets.all(12.0),
              
              child: TextFormField(
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: "Enter Phone Number",                                         
                  // labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone_android_outlined),
                  prefixIconColor: Colors.red,
                  hintStyle: TextStyle(fontSize:15,color:Colors.blue),
                  border:OutlineInputBorder()
                  ),
              ),
            ),
            Align(alignment: Alignment.topLeft,
              child:Text("Enter Password")),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: const TextField(
                keyboardType: TextInputType.phone,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  labelText: "Enter Password",
                  prefixIcon: Icon(Icons.password_outlined),
                  prefixIconColor:Colors.red,
                  hintStyle: TextStyle(fontSize:15,color:Colors.blue),
                  border:OutlineInputBorder()
                  ),
                  
              ),
              
            ),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) => maniPage(phone: FirstName),
              ), (route)=> false);
              // Navigator.of(context).push(MaterialPageRoute(builder: (cxt)=> maniPage(
              //   phone: FirstName,
              // )));
            },   style: ElevatedButton.styleFrom(backgroundColor: (Colors.yellow),),
            child: Text("Login", style:TextStyle(color:Colors.pink))),
            TextButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (cxt)=> Registrationpage()));
            }, child: Text("Don't you have account?"))
            // Image.asset("assets/images/food-image.png",fit: BoxFit.cover,),
            // Image.network("https://www.eatingwell.com/thmb/YxkWBfh2AvNYrDKoHukRdmRvD5U=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/article_291139_the-top-10-healthiest-foods-for-kids_-02-4b745e57928c4786a61b47d8ba920058.jpg",
            // height:100,width:100),
            // SizedBox(
            //   height:10
            // ),
            //  CachedNetworkImage(imageUrl: "https://www.eatingwell.com/thmb/YxkWBfh2AvNYrDKoHukRdmRvD5U=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/article_291139_the-top-10-healthiest-foods-for-kids_-02-4b745e57928c4786a61b47d8ba920058.jpg",
            //  height:100,width:100,
            //  errorWidget: (context, url, error) {
            //   return Text("Image Not Found");
            //  },
            //  placeholder: (context, url) {
            //   return Center(child:CircularProgressIndicator());
            //  },),
          ],
          
        ),
      )

    );
  }
  
}

