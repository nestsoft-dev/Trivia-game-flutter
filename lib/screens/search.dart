import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../constants/constant.dart';
import '../services/unity_ads.dart';
import 'single_quiz.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<int> points = [100, 120, 150, 150, 90, 100, 100, 100];
  List<int> diamonds = [2, 5, 5, 8, 2, 5, 2, 2];
  List<String> subjectNames = [
    'English',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Geography',

    'CRK',
    'IRS',
  ];
  List<String> lotties = [
    'assets/english.json',
    'assets/maths.json',
    'assets/scientist.json',
    'assets/scientist.json',
    'assets/biology.json',
    'assets/geography.json',
    'assets/religion.json',
    'assets/religion.json',
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(children: [
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
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5, mainAxisSpacing: 5, crossAxisCount: 2),
              itemCount: subjectNames.length,
              itemBuilder: (context, index) => Container(
                    height: 150,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: GestureDetector(
                      onTap: () {
                        MyAds().showRewards();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleQuizScreen(
                                      subject: 'english',
                                    )));
                      },
                      child: Column(
                        children: [
                          //avatar
                          CircleAvatar(
                            radius: 45,
                            child: Lottie.asset(lotties[index]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            subjectNames[index],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.mochiyPopPOne(
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
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
                              '${points[index]}points+ ${diamonds[index]}💎',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 35, 0, 82)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
        ),
      ]),
    );
  }
}
