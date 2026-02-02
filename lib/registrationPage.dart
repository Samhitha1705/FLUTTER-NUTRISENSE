import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/main.dart';

class Registrationpage extends StatefulWidget {
  const Registrationpage({super.key});

  @override
  State<Registrationpage> createState() => _RegistrationpageState();
}

class _RegistrationpageState extends State<Registrationpage> {

  bool visiblePassword = true;

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Registration Page"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding:EdgeInsets.all(10),
        child: Column(
          children:[
            SizedBox(height: 20,),
            CachedNetworkImage(imageUrl: "https://images.unsplash.com/photo-1600577916048-804c9191e36c?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",height:100),
            Text("Welcome to App, Stay Healthly and Stay Happy",textAlign: TextAlign.center,style: TextStyle(fontSize: 30),),
            SizedBox(height:15),
            Stack(
              children: [
                CircleAvatar(
                  radius:55,
                  backgroundImage: CachedNetworkImageProvider("https://static.vecteezy.com/system/resources/previews/010/056/184/non_2x/people-icon-sign-symbol-design-free-png.png"),
                ),
                Positioned
                (
                  bottom: 0,right:10,
                  child: Icon(Icons.camera_alt_rounded,size:30)),
              ],
            ),
            SizedBox(height:15),
            TextFormField(
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              controller: nameTextEditingController,
              maxLength:30,
              keyboardType:TextInputType.text,
              decoration: InputDecoration(
                hintText: "Enter Your Name",
                label: Text("Name"),
                counterText: "",
                prefixIcon: Icon(Icons.person),
                border:OutlineInputBorder()
              ),
            ),
            SizedBox(height:15),
            TextFormField(
              textInputAction: TextInputAction.next,
              onEditingComplete: (){
                FocusScope.of(context).nextFocus();
              },
              controller: emailTextEditingController,
              maxLength:30,
              keyboardType:TextInputType.text,
              decoration: InputDecoration(
                hintText: "Enter Your Email",
                label: Text("Email"),
                counterText: "",
                prefixIcon: Icon(Icons.email_outlined),
                border:OutlineInputBorder()
              ),
            ),
            SizedBox(height:15),
            TextFormField(
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              onFieldSubmitted: (value) {
                validate();
              },
              controller: passwordTextEditingController,
              maxLength:30,
              obscureText: visiblePassword,
              keyboardType:TextInputType.text,
              decoration: InputDecoration(
                hintText: "Enter Your Paasword",
                label: Text("Password"),
                counterText: "",
                prefixIcon: Icon(Icons.password_outlined),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      visiblePassword = !visiblePassword;
                    });
                  },
                child: Icon(visiblePassword? Icons.visibility_outlined:Icons.visibility_off_outlined),),
                border:OutlineInputBorder()
              ),
            ),
            SizedBox(height:10),
            ElevatedButton(onPressed: (){
              print(nameTextEditingController.text);
              validate();
              FocusScope.of(context).unfocus();
              // Navigator.of(context).push(MaterialPageRoute(builder: (cxt)=>MyApp()));
            }, child: Text("Register")),
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Already have Account?",style: TextStyle(color: Colors.blue),))
          ]
        ),
      ),
    );
  }

  validate(){
    String name, email, password;
    name = nameTextEditingController.text;
    email = emailTextEditingController.text;
    password = passwordTextEditingController.text;
    if(name.isEmpty){
      Fluttertoast.showToast(msg: "Enter valid Name");
    }else if(email.isEmpty || email.length < 10){
      Fluttertoast.showToast(msg: "Enter valid Email");
    }else if(password.isEmpty){
      Fluttertoast.showToast(msg: "Enter valid Password");
    }else{
      Fluttertoast.showToast(msg: "Succesfully Registered");
      // Navigator.of(context).push(MaterialPageRoute(builder: (cxt)=>MyApp()));
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) => MyApp(FirstName: name),
      ), (route)=> false);
    }
  }
}