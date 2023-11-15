import 'dart:async';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:flutter_pollfish/flutter_pollfish.dart';

import '../constants/constant.dart';
import '../firebase/firebase_functions.dart';
import '../model/user_model.dart';
import '../pages/show_sub_list.dart';
import '../pages/survey.dart';
import '../services/admob__ads.dart';
import '../services/in_app_review.dart';
import '../services/purchases.dart';
import '../widgets/chat_banner.dart';
import '../widgets/home_banner.dart';
import '../widgets/homepage_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/my_shrimmer.dart';
import '../widgets/refer_card.dart';
import '../widgets/withdrawal_card.dart';
import 'payment.dart';
import 'single_quiz.dart';

// Use RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("1DB973C1BF1CDA26F3EF22215E0ADCE1")) to get test ads on this device

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
    'Commercial',
    'Art',
  ];
  List<String> desc = [
    'Test your maths skills in cal',
    'Prove that you are a scientist',
    'Lets See how Good you are!',
    'Show the Artist in you in art',
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
  FirebaseFun _firebaseFun = FirebaseFun();
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  List<ProductDetails> _products = [];

  final userProperties = {
    "gender": "1",
    "year_of_birth": "1974",
    "marital_status": "2",
    "parental": "3",
    "education": "1",
    "employment": "1",
    "career": "2",
    "race": "3",
    "income": "1",
  };

  void onPollfishSurveyCompleted(SurveyInfo sureyInfo) {
    int newPoints = pointsVal + sureyInfo.rewardValue!;
    FirebaseFun().uploadPoints(newPoints);
  }

  @override
  void initState() {
    checkForUpdate();
    greetings();
    FlutterPollfish.instance.init(
        androidApiKey: pollfish,
        iosApiKey: null,
        placementId: 'c8d45648-491d-4dd0-abdf-d9fc47900f83',
        releaseMode: true,
        indicatorPadding: 8,
        userProperties: userProperties,
        indicatorPosition: Position.topRight,
        requestUUID: FirebaseAuth.instance.currentUser!.uid,
        rewardMode: true,
        rewardInfo: RewardInfo('Point', 10.0)); // Android only

    FlutterPollfish.instance.setPollfishSurveyCompletedListener(
        (surveyInfo) => onPollfishSurveyCompleted(surveyInfo!));
    FlutterPollfish.instance.show();
    //  Timer(const Duration(seconds: 5), () {
    _ratingService.isSecondTimeOpen().then((value) {
      if (value) {
        _ratingService.showRating();
      }
    });
    setSubList();
    // });

    super.initState();
    UnityAds.load(
      placementId: 'Interstitial_Android',
      onComplete: (adUnitId) {
        print('Rewarded Ad Load Unity Complete $adUnitId');
      },
      onFailed: (adUnitId, error, message) =>
          print('Rewarded Ad Load Failed $adUnitId: $error $message'),
    );
    UnityAds.load(
      placementId: 'Rewarded_Android',
      onComplete: (adUnitId) {
        Future.delayed(Duration(seconds: 5))
            .then((value) => UnityAds.showVideoAd(
                  placementId: 'Rewarded_Android',
                  onFailed: (adUnitId, error, message) {},
                  onStart: (adUnitId) {},
                  onClick: (adUnitId) {},
                  onComplete: (reward) {},
                ));
      },
      onFailed: (adUnitId, error, message) =>
          print('Rewarded Ad Load Failed $adUnitId: $error $message'),
    );
  }

  @override
  void dispose() {
    FlutterPollfish.instance.removeListeners();
    super.dispose();
  }
  //FlutterPollfish.instance.

  setSubList() async {
    setState(() {
      _products = BuyDiamonds().products;
    });
    print("the sub list is ${_products}");
  }

  showSubList() => showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        print('${_products[index].price}');
                        BuyDiamonds().purchase(_products[index]);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(
                            '${_products[index].description}',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          trailing: Text(
                            '${_products[index].price}',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    )),
          ),
        );
      });

  List<String> artSubjects = [
    'English',
    'CRK',
    'IRS',
  ];

  List<String> scienceSubjects = [
    'Physics',
    'Chemistry',
    'Biology',
    'Geography',
    'Mathematics',
  ];

  List<String> commercialSubjects = [
    'Mathematics',
  ];

  String randomSubject = '';
  String getRandomSubject(List subjectNames) {
    Random random = Random();
    int randomIndex = random.nextInt(subjectNames.length);
    return subjectNames[randomIndex];
  }

  int pointsVal = 0;
  showMyDialog(int index) {
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
                            switch (index) {
                              case 0:
                                UnityAds.showVideoAd(
                                  placementId: 'Interstitial_Android',
                                  onFailed: (adUnitId, error, message) {},
                                  onStart: (adUnitId) {},
                                  onClick: (adUnitId) {},
                                  onComplete: (adUnitId) {},
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingleQuizScreen(
                                              subject: 'mathematics',
                                            )));
                                break;
                              case 1:
                                UnityAds.showVideoAd(
                                  placementId: 'Interstitial_Android',
                                  onFailed: (adUnitId, error, message) {},
                                  onStart: (adUnitId) {},
                                  onClick: (adUnitId) {},
                                  onComplete: (adUnitId) {},
                                );
                                randomSubject =
                                    getRandomSubject(scienceSubjects);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingleQuizScreen(
                                              subject:
                                                  randomSubject.toLowerCase(),
                                            )));
                                break;
                              case 2:
                                UnityAds.showVideoAd(
                                  placementId: 'Interstitial_Android',
                                  onFailed: (adUnitId, error, message) {},
                                  onStart: (adUnitId) {},
                                  onClick: (adUnitId) {},
                                  onComplete: (adUnitId) {},
                                );
                                randomSubject =
                                    getRandomSubject(commercialSubjects);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingleQuizScreen(
                                              subject:
                                                  randomSubject.toLowerCase(),
                                            )));
                                break;
                              case 3:
                                UnityAds.showVideoAd(
                                  placementId: 'Interstitial_Android',
                                  onFailed: (adUnitId, error, message) {},
                                  onStart: (adUnitId) {},
                                  onClick: (adUnitId) {},
                                  onComplete: (adUnitId) {},
                                );
                                randomSubject = getRandomSubject(artSubjects);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingleQuizScreen(
                                              subject:
                                                  randomSubject.toLowerCase(),
                                            )));
                                break;
                              default:
                            }
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
      body: StreamBuilder<DocumentSnapshot>(
          stream: _firebaseFun.getuserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                Map<String, dynamic> userData =
                    snapshot.data!.data() as Map<String, dynamic>;
                UserModel user = UserModel.fromMap(userData);
                pointsVal = user.point;
                return ListView(children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  HomePageBar(
                    greetings: _greeting,
                    icon: icontype!,
                    name: user.name!,
                    usserImage: user.userImage!,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BannerHome(
                    size: size,
                    diamonds: user.diamonds!,
                    points: user.point!,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowSubist()));
                    },
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
                                child: GestureDetector(
                                    onTap: () async {
                                      await FlutterShare.share(
                                          title: 'Join us and Learn',
                                          text:
                                              'Join the winning team and earn cool rewards of giftscards and paypals funds using this promo code ${user.referralCode}',
                                          linkUrl:
                                              'https://play.google.com/store/apps/details?id=com.netsoftdevelopers.trival_game',
                                          chooserTitle: 'Join And Earn');
                                    },
                                    child: ReferralBanner(size: size)));
                          } else {
                            return BounceInDown(
                                duration: const Duration(seconds: 2),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RedeemPoints()));
                                    },
                                    child: WithdrawalBanner(size: size)));
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UnityBannerAd(
                      placementId: 'Banner_Android',
                      onLoad: (adUnitId) => print('Banner loaded: $adUnitId'),
                      onClick: (adUnitId) => print('Banner clicked: $adUnitId'),
                      onFailed: (adUnitId, error, message) =>
                          print('Banner Ad $adUnitId failed: $error $message'),
                    ),
                  ),
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
                                style: TextStyle(
                                    color: defaultButton, fontSize: 25),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text('Select Any'))
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
                                      onTap: () => showMyDialog(index),
                                      child: Container(
                                        height: 90,
                                        width: size.width,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: defaultButton, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //image
                                              CircleAvatar(
                                                radius: 30,
                                                child: Lottie.asset(
                                                    lotties[index]),
                                              ),

                                              //column-->subject-->des
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      subjects[index],
                                                      style: GoogleFonts
                                                          .mochiyPopPOne(
                                                              fontSize: 18),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      desc[index],
                                                      style:
                                                          GoogleFonts.poppins(),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              //arrow start
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                      FontAwesomeIcons
                                                          .arrowRight))
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
                ]);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            } else if (snapshot.hasError) {
              return Text('Error');
            } else {
              return MyShrimmer();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //FlutterPollfish.instance.show();

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BitLabSurvey()));
        },
        child: const Icon(Icons.gamepad),
      ),
    );
  }
}
