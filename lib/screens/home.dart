import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import '../constants/constant.dart';
import '../services/in_app_review.dart';
import '../widgets/chat_banner.dart';
import '../widgets/home_banner.dart';
import '../widgets/homepage_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/refer_card.dart';
import '../widgets/withdrawal_card.dart';
import 'single_quiz.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _greeting = '';
  IconData? icontype;
  greetings() {
    final currentTime = DateTime.now();
    final formatter = DateFormat('HH');

    final hour = int.parse(formatter.format(currentTime));

    if (hour >= 0 && hour < 12) {
      setState(() {
        icontype = Icons.sunny_snowing;
        _greeting = 'Good Morning';
      });
    } else if (hour >= 12 && hour < 18) {
      setState(() {
        icontype = FontAwesomeIcons.sun;
        _greeting = 'Good Afternoon';
      });
    } else {
      setState(() {
        icontype = FontAwesomeIcons.moon;
        _greeting = 'Good Evening';
      });
    }
  }

  List<String> subjects = [
    'Mathematics',
    'Science',
    'Geography',
    'Art',
  ];
  List<String> desc = [
    'Test your maths skills',
    'Prove that you are a scientist',
    'Lets See how Good you are!',
    'Show the Artist in you',
  ];

  List<String> lotties = [
    'assets/maths.json',
    'assets/scientist.json',
    'assets/geography.json',
    'assets/art.json',
  ];

//in app update
  AppUpdateInfo? _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final bool _flexibleUpdateAvailable = false;
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
          ? InAppUpdate.performImmediateUpdate()
          : AppUpdateResult.inAppUpdateFailed;
      setState(() {
        _updateInfo = info;
      });
      _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
          ? InAppUpdate.performImmediateUpdate()
          : AppUpdateResult.inAppUpdateFailed;
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  final MyInAppReview _ratingService = MyInAppReview();
  @override
  void initState() {
    //checkForUpdate();
    greetings();
    Timer(const Duration(seconds: 5), () {
      _ratingService.isSecondTimeOpen().then((value) {
        if (value) {
          _ratingService.showRating();
        }
      });
    });

    super.initState();
  }

  showMyDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Be informed'),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width - 60,
                child: Column(
                  children: [
                    //title
                    Text(
                      'You are about to take Quiz',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mochiyPopPOne(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color.fromARGB(255, 35, 0, 82)),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Lottie.asset('assets/bell.json', height: 100, width: 100),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Rule: Once you fail a Question,\n you lose reward of 400+ and diamonds',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: const Color.fromARGB(255, 35, 0, 82)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    //close button and open
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                         SingleQuizScreen(subject: 'english',)));
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: defaultButton,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              'Agreed?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              'Nop',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: defaultButton,
      body: ListView(children: [
        SizedBox(
          height: size.height * 0.05,
        ),
        HomePageBar(
          greetings: _greeting,
          icon: icontype!,
        ),
        const SizedBox(
          height: 10,
        ),
        BannerHome(
          size: size,
          diamonds: 0,
        ),
        const SizedBox(
          height: 35,
        ),
        Container(
          height: size.height * 0.27,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return FadeOut(child: ChatBanner(size: size));
                } else if (index == 1) {
                  return BounceInRight(
                      duration: Duration(seconds: 5),
                      child: ReferralBanner(size: size));
                } else {
                  return BounceInDown(
                      duration: Duration(seconds: 2),
                      child: WithdrawalBanner(size: size));
                }
              }),
        ),

        // const Spacer(),
        const SizedBox(
          height: 40,
        ),
        Container(
          height: size.height * 0.48,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Quiz',
                      style: TextStyle(color: defaultButton, fontSize: 25),
                    ),
                    TextButton(
                        onPressed: () {}, child: const Text('Select Any'))
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 5, right: 10, left: 10),
                          child: GestureDetector(
                            onTap: () => showMyDialog(),
                            child: Container(
                              height: 90,
                              width: size.width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: defaultButton, width: 1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //image
                                    CircleAvatar(
                                      radius: 30,
                                      child: Lottie.asset(lotties[index]),
                                    ),

                                    //column-->subject-->des
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subjects[index],
                                            style: GoogleFonts.mochiyPopPOne(
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            desc[index],
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //arrow start
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.arrowRight))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }))
            ],
          ),
        )
      ]),
    );
  }
}
