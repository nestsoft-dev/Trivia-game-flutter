import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constant.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerCenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
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
                      color: lighyellow, width: 5, style: BorderStyle.solid)),
              child: Column(
                children: [
                  //sucess image -->sucess text
                  //complement text

                  Text(
                    'Score',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mochiyPopPOne(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Color.fromARGB(255, 35, 0, 82)),
                  ),
                  //container with score
                  Text(
                    'Rewards',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mochiyPopPOne(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Colors.blue),
                  ),
                  //containers with rewards

                  //happy lottie

                  //Choose subject again

                  //container to return home
                ],
              ),
            )
          ]),
        ),
        ConfettiWidget(
          confettiController: _controllerCenter,
          blastDirection: -pi / 2,
          emissionFrequency: 0.05,
        )
      ],
    );
  }
}
