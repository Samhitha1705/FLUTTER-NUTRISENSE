import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Personsuggest extends StatelessWidget {
  const Personsuggest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
              Row(
                children: [
                  Expanded(
                    flex: 30,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: CachedNetworkImageProvider("https://media.licdn.com/dms/image/v2/D5603AQHMBQ1jHxGpag/profile-displayphoto-scale_200_200/B56Zs1479qJ8AY-/0/1766135678734?e=2147483647&v=beta&t=LlZps5fkgs8qc7ZdTcSErB2dfM1FDlGAJSRYOrbmPtI"),
                    ),
                  ),
                  Expanded(
                    flex: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        myProfile("60", "Weight"),
                        myProfile("6.3", "Height"),
                        myProfile("97", "BMI")
                      ],
                    ),
                  )
                ],
              ),
              
          ],
        ),
      )
    );
  }

Widget myProfile(String count, String info ){
  return Column(children: [
    Text(count,style:TextStyle(fontSize: 25,color: Colors.blue),),
    Text(info, style: TextStyle(fontSize: 18,color: Colors.black),)
  ],);
}
}