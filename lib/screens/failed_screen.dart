import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constant.dart';

class FailedScreen extends StatefulWidget {
  const FailedScreen({super.key});

  @override
  State<FailedScreen> createState() => _FailedScreenState();
}

class _FailedScreenState extends State<FailedScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: size.height * 0.1,
        ),
        Container(
          height: size.height * 0.30,
          width: size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.pinkAccent,
              border: Border.all(
                  color:  lighyellow, width: 5, style: BorderStyle.solid)),
                  child: Column(children: [

                    //failed image -->failed text
                    //complement text

                    Text('Score',
                textAlign: TextAlign.center,
                style: GoogleFonts.mochiyPopPOne(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Color.fromARGB(255, 35, 0, 82)),
              ),
                    //container with score
              Text('Rewards',
                textAlign: TextAlign.center,
                style: GoogleFonts.mochiyPopPOne(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.yellowAccent),
              ),
              //containers with rewards

              //sad lottie 

              //retry



              //container to return home

                  ],),
        )
      ]),
    );
  }
}
