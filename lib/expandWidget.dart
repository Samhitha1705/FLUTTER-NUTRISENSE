import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class expandFlex extends StatefulWidget {
  const expandFlex({super.key});

  @override
  State<expandFlex> createState() => _ExpandwidgetState();
}

class _ExpandwidgetState extends State<expandFlex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 30,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider("https://media.licdn.com/dms/image/v2/D5603AQHMBQ1jHxGpag/profile-displayphoto-scale_200_200/B56Zs1479qJ8AY-/0/1766135678734?e=2147483647&v=beta&t=LlZps5fkgs8qc7ZdTcSErB2dfM1FDlGAJSRYOrbmPtI"),
                  radius: 50,
                ),
              ),
              Expanded(
                flex: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    profileDetails("Weight", "66"),
                    profileDetails("Height", "6.5"),
                    profileDetails("BMI","94"),
                  ],
                ),
              )
            ],
          ),
          Column(children: [
            Text("Personal Information",style: TextStyle(fontSize: 30, color: Colors.black),),
            Text("Height:"),
            Text("Weight:"),
            Text("BMI:"),
          ],)
        ],
        
      ),
    );
  }
  Widget profileDetails(String count, String name ){
    return Column(children: [
      Text(name),
      Text(count)
    ],);
  }
}