import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../constants/constant.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> subjectNames = [
    'English',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Geography',
    'Government',
    'CRK',
    'IRS',
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
        BackdropFilter(filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1)),
        Expanded(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5, mainAxisSpacing: 5, crossAxisCount: 2),
              itemCount: 11,
              itemBuilder: (context, index) => Container(
                    height: 150,
                    //  padding: EdgeInsets.only(bott),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        //avatar
                        CircleAvatar(
                          radius: 45,
                          child: Lottie.asset('assets/maths.json'),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          subjectNames[index].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.mochiyPopPOne(
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
                              color: Color.fromARGB(255, 35, 0, 82)),
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.yellowAccent.withOpacity(0.3)),
                          child: Text(
                            '400points+ 15💎',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Color.fromARGB(255, 35, 0, 82)),
                          ),
                        ),
                      ],
                    ),
                  )),
        ),
      ]),
    );
  }
}
