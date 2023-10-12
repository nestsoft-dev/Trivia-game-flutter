import 'dart:math';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
          body: Stack(
            children: [
              Align(
                alignment: Alignment(1, -1),
                child: Container(
                  height: 250,
                  width: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lighBlue.withOpacity(0.8),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(1, 0),
                child: Container(
                  height: 250,
                  width: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: darkblue.withOpacity(0.8),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-1, 1),
                child: Container(
                  height: 250,
                  width: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: darkblue.withOpacity(0.8),
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  FadeInDown(
                    duration: const Duration(milliseconds: 1500),
                    child: Container(
                      height: size.height * 0.35,
                      width: size.width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.pinkAccent,
                          border: Border.all(
                              color: lighyellow,
                              width: 5,
                              style: BorderStyle.solid)),
                      child: Column(
                        children: [
                          //sucess image -->sucess text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/sucess.json',
                                  height: 50, width: 50),
                              Text(
                                'Wow Congrats\nyou did it.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mochiyPopPOne(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                    color: Colors.yellow[700]),
                              ),
                            ],
                          ),
                          //complement text
                          const SizedBox(
                            height: 15,
                          ),

                          Text(
                            'Score',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.mochiyPopPOne(
                                fontWeight: FontWeight.w500,
                                fontSize: 25,
                                color: Color.fromARGB(255, 35, 0, 82)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.yellowAccent.withOpacity(0.3)),
                            child: Text(
                              '400points',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 35, 0, 82)),
                            ),
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
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.blue.withOpacity(0.3)),
                            child: Text(
                              '400points+ 15💎',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 35, 0, 82)),
                            ),
                          ),
                          //containers with rewards

                          //happy lottie

                          //Choose subject again

                          //container to return home
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.10,
                  ),
                  Container(
                    height: 65,
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.pinkAccent,
                        border: Border.all(
                            color: lighyellow,
                            width: 5,
                            style: BorderStyle.solid)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Back Home',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Icon(
                            FontAwesomeIcons.house,
                            color: Colors.white,
                            size: 24,
                          )
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
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
