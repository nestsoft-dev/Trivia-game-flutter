// ignore_for_file: public_member_api_docs, sort_constructors_first, dead_code_catch_following_catch
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:onepref/onepref.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trival_game/firebase/firebase_functions.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../constants/constant.dart';
import '../model/question_model.dart';
import '../model/user_model.dart';
import '../services/admob__ads.dart';
import '../services/unity_ads.dart';
import '../widgets/my_shrimmer.dart';
import '../widgets/my_snack.dart';
import '../widgets/quiz_card.dart';
import 'rewards_screen.dart';

class SingleQuizScreen extends StatefulWidget {
  String subject;
  SingleQuizScreen({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  State<SingleQuizScreen> createState() => _SingleQuizScreenState();
}

class _SingleQuizScreenState extends State<SingleQuizScreen> {
  final CardSwiperController controller = CardSwiperController();
  String selectedOption = '';

  PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    timer?.cancel();
    _pageController.dispose();
  }

  bool _isLoading = true;

  Future<void> getQuestions() async {
    try {
      // https: //questions.aloc.com.ng/api/v2/m/100?subject=chemistry
      // // 'https://questions.aloc.com.ng/api/v2/q/50?subject=${subject[0]}&year=$year&type=$type'),
      var request = http.get(
          Uri.parse(
              'https://questions.aloc.com.ng/api/v2/q/40?subject=${widget.subject}'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'AccessToken': API_KEY
          }).then((value) {
        if (value.statusCode == 200) {
          var data = jsonDecode(value.body);
          //  print(data);
          setState(() {
            questions = data['data'];
            _isLoading = false;
          });
          startTimer();

          print('${data['data']}');
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  int _selectedIndex = -1;
  var isAnswer;
  int _currentPageIndex = 0;
  int _score = 0;
  bool ispressed = false;
  double balance = 0;
  int points = 0;
  int diamonds = 0;

  void _checkAnswer(String selectedOption) {
    if (questions[_currentPageIndex]['answer'] == selectedOption) {
      setState(() {
        _score += 10;
      });

      print('${questions[_currentPageIndex]['answer']}');
    }
    _goToNextQuestion();
  }

  Future<void> _goToNextQuestion() async {
    print('next screen');
    if (_currentPageIndex < questions.length - 1) {
      setState(() {
        _currentPageIndex++;
        selectedOption = '';
        answer = '';
      });
      _pageController.animateToPage(_currentPageIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      _interstitialAd!.show();
//submit
      int newP = points + _score;
      int newD = diamonds < 30 ? 1 : 3;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => RewardsScreen(
                    points: newP,
                    diamonds: newD,
                    defPoint: _score,
                    defDiamond: newD,
                  )),
          (route) => false);
    }
  }

  Timer? timer;
  int time = 0;
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: AdmobAds.bannerId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }

  startTimer() {
    time = 10;

    timer = Timer.periodic(Duration(minutes: 1), (_) async {
      if (time! > 0) {
        setState(() {
          time--;
        });

        if (time! < 5) {
          // final player = AudioPlayer();
          // player.play(AssetSource('jsons/td_tick.mp3'));
          MySnack(context, 'Running low on Time watch ads to increase Time',
              Colors.red);
        }
      } else if (time == 0) {
        int newP = points + _score;
        int newD = diamonds < 30 ? 1 : 3;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => RewardsScreen(
                      points: newP,
                      diamonds: newD,
                      defPoint: _score,
                      defDiamond: newD,
                    )),
            (route) => false);

        timer?.cancel();
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getQuestions();
    loadBanner();
    loadAdInter();
    loadRewardsAds();
    //startTimer();
  }

  RewardedAd? _rewardedAd;
  loadRewardsAds() {
    RewardedAd.load(
        adUnitId: AdmobAds.rewarded,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            setState(() {
              _isRewardedLoaded = true;
            });
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  bool _isRewardedLoaded = false;
  InterstitialAd? _interstitialAd;
  void loadAdInter() {
    InterstitialAd.load(
        adUnitId: AdmobAds.inter,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  // void creditUser(PurchaseDetails purchaseDetails) async {
  //   for (var product in storeProductIds) {
  //     if (product.id == purchaseDetails.productID) {
  //       int newDiamond = diamonds + product.reward!;
  //       FirebaseFun().uploadPurchaseDiamond(newDiamond);
  //     }
  //   }
  // }

  List<ProductId> storeProductIds = [
    ProductId(id: 'diamond_10', isConsumable: true, reward: 10),
    ProductId(id: 'diamond_30', isConsumable: true, reward: 30),
    ProductId(id: 'diamond_60', isConsumable: true, reward: 60),
    //ProductId(id: 'id', isConsumable: true, reward: 10),
  ];

  //show

  double percentValue = 0.0;

  List<dynamic> questions = [
    // {
    //   "id": 517,
    //   "question": "  understandable ",
    //   "option": {
    //     "a": "unDERstandable",
    //     "b": "understandABLE",
    //     "c": "UNderstandable ",
    //     "d": "underSTANDable.",
    //     "e": "underSTANDable."
    //76d0093c-ec62-4d08-85c0-b2766efcbffc
    //   },
    //   "section":
    //       "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
    //   "image": "",
    //   "answer": "d",
    //   "solution": "",
    //   "examtype": "utme",
    //   "examyear": "2009",
    //   "questionNub": null,
    //   "hasPassage": 0,
    //   "category": "others"
    // },
    // {
    //   "id": 391,
    //   "question": "His <i>kind-hearted</i> master bought him a motorcycle",
    //   "option": {
    //     "a": " stingy   ",
    //     "b": "generous    ",
    //     "c": " shrewd ",
    //     "d": "angry.",
    //     "e": "angry."
    //   },
    //   "section":
    //       "choose the option opposite in meaning to the word or phrase in italics.",
    //   "image": "",
    //   "answer": "d",
    //   "solution": "",
    //   "examtype": "utme",
    //   "examyear": "2008",
    //   "questionNub": null,
    //   "hasPassage": 0,
    //   "category": "others"
    // },
    // {
    //   "id": 517,
    //   "question": "  understandable ",
    //   "option": {
    //     "a": "unDERstandable",
    //     "b": "understandABLE",
    //     "c": "UNderstandable ",
    //     "d": "underSTANDable.",
    //     "e": "underSTANDable."
    //   },
    //   "section":
    //       "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
    //   "image": "",
    //   "answer": "d",
    //   "solution": "",
    //   "examtype": "utme",
    //   "examyear": "2009",
    //   "questionNub": null,
    //   "hasPassage": 0,
    //   "category": "others"
    // },
    // {
    //   "id": 517,
    //   "question": "  understandable ",
    //   "option": {
    //     "a": "unDERstandable",
    //     "b": "understandABLE",
    //     "c": "UNderstandable ",
    //     "d": "underSTANDable.",
    //     "e": "underSTANDable."
    //   },
    //   "section":
    //       "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
    //   "image": "",
    //   "answer": "d",
    //   "solution": "",
    //   "examtype": "utme",
    //   "examyear": "2009",
    //   "questionNub": null,
    //   "hasPassage": 0,
    //   "category": "others"
    // },
    // {
    //   "id": 517,
    //   "question": "  understandable ",
    //   "option": {
    //     "a": "unDERstandable",
    //     "b": "understandABLE",
    //     "c": "UNderstandable ",
    //     "d": "underSTANDable.",
    //     "e": "underSTANDable."
    //   },
    //   "section":
    //       "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
    //   "image": "",
    //   "answer": "d",
    //   "solution": "",
    //   "examtype": "utme",
    //   "examyear": "2009",
    //   "questionNub": null,
    //   "hasPassage": 0,
    //   "category": "others"
    // },
    // {
    //   "id": 517,
    //   "question": "  understandable ",
    //   "option": {
    //     "a": "unDERstandable",
    //     "b": "understandABLE",
    //     "c": "UNderstandable ",
    //     "d": "underSTANDable.",
    //     "e": "underSTANDable."
    //   },
    //   "section":
    //       "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
    //   "image": "",
    //   "answer": "d",
    //   "solution": "",
    //   "examtype": "utme",
    //   "examyear": "2009",
    //   "questionNub": null,
    //   "hasPassage": 0,
    //   "category": "others"
    // },
    // {
    //   "id": 517,
    //   "question": "  understandable ",
    //   "option": {
    //     "a": "unDERstandable",
    //     "b": "understandABLE",
    //     "c": "UNderstandable ",
    //     "d": "underSTANDable.",
    //     "e": "underSTANDable."
    //   },
    //   "section":
    //       "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
    //   "image": "",
    //   "answer": "d",
    //   "solution": "",
    //   "examtype": "utme",
    //   "examyear": "2009",
    //   "questionNub": null,
    //   "hasPassage": 0,
    //   "category": "others"
    // },
    // {
    //   "id": 517,
    //   "question": "  understandable ",
    //   "option": {
    //     "a": "unDERstandable",
    //     "b": "understandABLE",
    //     "c": "UNderstandable ",
    //     "d": "underSTANDable.",
    //     "e": "underSTANDable."
    //   },
    //   "section":
    //       "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
    //   "image": "",
    //   "answer": "d",
    //   "solution": "",
    //   "examtype": "utme",
    //   "examyear": "2009",
    //   "questionNub": null,
    //   "hasPassage": 0,
    //   "category": "others"
    // },
  ];
  int questionIndex = 0;
  String? percentString;

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (currentIndex != null && questions != null && questions.length != 0) {
      percentValue = currentIndex / questions.length;
    } else {
      percentValue = 1.0; // You can choose another default value if needed.
    }
    //debugPrint('${percentValue = currentIndex / questions.length}');
    setState(() {
      // percentValue = (currentIndex! / questions.length)! ?? 1;
    });
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );

    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }

  int hint = 2;
  // int? questionIndex;

  showHint(int diamonds) async {
    int newD = diamonds - hint;
    await FirebaseFun().uploadPurchaseDiamond(newD);
  }

  // showPercent() {
  //   if (_currentPageIndex != null &&
  //       questions != null &&
  //       questions.length != 0) {
  //     percentValue = _currentPageIndex / questions.length;
  //   } else {
  //     percentValue = 1.0; // You can choose another default value if needed.
  //   }
  //   //debugPrint('${percentValue = currentIndex / questions.length}');
  //   setState(() {
  //     // percentValue = (currentIndex! / questions.length)! ?? 1;
  //   });
  // }

  String answer = '';
  // checkScore(String selectedOption, String optionKey) {
  //   if (selectedOption == optionKey) {
  //     points += 10;
  //   }
  //   goNextQuestion();
  // }
  // goNextQuestion(){

  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: time < 5
            ? FloatingActionButton(
                onPressed: _isRewardedLoaded
                    ? () {
                        _rewardedAd!.show(onUserEarnedReward: (adview, reward) {
                          setState(() {
                            time += 3;
                          });
                        });
                      }
                    : () async {
                        UnityAds.showVideoAd(
                          placementId: 'Rewarded_Android',
                          onFailed: (adUnitId, error, message) {},
                          onStart: (adUnitId) {},
                          onClick: (adUnitId) {},
                          onComplete: (reward) => setState(() {
                            time += 3;
                          }),
                        );
                      },
                child: Icon(
                  Icons.video_call,
                  color: Colors.yellow[700],
                ),
              )
            : const SizedBox.shrink(),
        backgroundColor: Colors.blue,
        body: _isLoading
            ? const MyShrimmer()
            : StreamBuilder(
                stream: FirebaseFun().getuserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    UserModel usermodel = UserModel.fromMap(data);
                    diamonds = usermodel.diamonds;
                    points = usermodel.point;

                    // return Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 15),
                    //   child: ListView(children: [
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 15),
                    //       child: SizedBox(
                    //         height: 55,
                    //         width: size.width,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             //points gotten
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Container(
                    //                   padding: const EdgeInsets.all(10),
                    //                   decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(12),
                    //                       color: Colors.yellowAccent
                    //                           .withOpacity(0.3)),
                    //                   child: Text(
                    //                     '$_score points',
                    //                     textAlign: TextAlign.center,
                    //                     style: GoogleFonts.poppins(
                    //                         fontWeight: FontWeight.w500,
                    //                         fontSize: 18,
                    //                         color:
                    //                             Color.fromARGB(255, 35, 0, 82)),
                    //                   ),
                    //                 ),
                    //                 const SizedBox(width: 5),
                    //                 usermodel.diamonds < 2
                    //                     ? ElevatedButton(
                    //                         onPressed: () {
                    //                           MySnack(
                    //                               context,
                    //                               'Buying of Diamonds coming soon',
                    //                               Colors.deepPurple);
                    //                         },
                    //                         child: const Text('Buy Diamonds'))
                    //                     : GestureDetector(
                    //                         onTap: usermodel.diamonds < 2
                    //                             ? () => MySnack(
                    //                                 context,
                    //                                 'Low on Diamonds',
                    //                                 Colors.deepPurple)
                    //                             : () {
                    //                                 showHint(diamonds);
                    //                                 setState(() {
                    //                                   answer = questions[
                    //                                           questionIndex]
                    //                                       ['answer'];
                    //                                 });
                    //                               },
                    //                         child: Container(
                    //                           padding: const EdgeInsets.all(10),
                    //                           decoration: BoxDecoration(
                    //                               borderRadius:
                    //                                   BorderRadius.circular(12),
                    //                               color: Color(0xFFE040FB)
                    //                                   .withOpacity(0.3)),
                    //                           child: Text(
                    //                             '🔔Hint💎-2',
                    //                             textAlign: TextAlign.center,
                    //                             style: GoogleFonts.poppins(
                    //                                 fontWeight: FontWeight.w500,
                    //                                 fontSize: 18,
                    //                                 color: Color.fromARGB(
                    //                                     255, 35, 0, 82)),
                    //                           ),
                    //                         ),
                    //                       ),
                    //               ],
                    //             ),

                    //             Container(
                    //               padding: const EdgeInsets.all(10),
                    //               decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(12),
                    //                   color:
                    //                       Colors.yellowAccent.withOpacity(0.3)),
                    //               child: Text(
                    //                 '$time ⏰',
                    //                 textAlign: TextAlign.center,
                    //                 style: GoogleFonts.poppins(
                    //                     fontWeight: FontWeight.w500,
                    //                     fontSize: 18,
                    //                     color: Color.fromARGB(255, 35, 0, 82)),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       height: size.height * 0.65,
                    //       child: CardSwiper(
                    //           controller: controller,
                    //           isLoop: false,
                    //           onEnd: () {
                    //             MyAds().showInter();

                    //             controller.dispose();
                    //             int newP = points + _score;
                    //             int newD = diamonds < 30 ? 1 : 3;
                    //             Navigator.pushAndRemoveUntil(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (context) => RewardsScreen(
                    //                           points: newP,
                    //                           diamonds: newD,
                    //                           defPoint: _score,
                    //                           defDiamond: newD,
                    //                         )),
                    //                 (route) => false);
                    //           },
                    //           initialIndex: 0,
                    //           cardsCount: questions.length != null
                    //               ? questions.length
                    //               : 5,
                    //           onSwipe: _onSwipe,
                    //           onUndo: _onUndo,
                    //           numberOfCardsDisplayed: 3,
                    //           backCardOffset: const Offset(40, 40),
                    //           padding: const EdgeInsets.all(24.0),
                    //           cardBuilder: (
                    //             context,
                    //             index,
                    //             horizontalThresholdPercentage,
                    //             verticalThresholdPercentage,
                    //           ) {
                    //             Map<String, dynamic> question =
                    //                 questions[index];

                    //             return Card(
                    //               margin: EdgeInsets.all(16),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(16.0),
                    //                 child: Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(question['question']),
                    //                     SizedBox(height: 16),
                    //                     ...question['option']
                    //                         .entries
                    //                         .map((entry) {
                    //                       final optionKey = entry.key;
                    //                       final optionValue = entry.value;
                    //                       return ListTile(
                    //                         title: Text(optionValue),
                    //                         leading: Radio(
                    //                             value: optionKey,
                    //                             groupValue:
                    //                                 selectedOption, // question['answer'],
                    //                             onChanged: (value) {
                    //                               setState(() {
                    //                                 selectedOption =
                    //                                     value as String;
                    //                               });
                    //                             }),
                    //                       );
                    //                     }).toList(),
                    //                   ],
                    //                 ),
                    //               ),
                    //             );
                    //             // return QuizCard(
                    //             //   question: question,
                    //             //   currentIndex: index,
                    //             // );
                    //           }),
                    //     ),
                    //     const SizedBox(
                    //       height: 25,
                    //     ),

                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Text(
                    //         '$answer',
                    //         style: const TextStyle(
                    //             color: Colors.white, fontSize: 18),
                    //       ),
                    //     ),
                    //     //show progress of the question
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 25),
                    //   child: Flexible(
                    //     child: LinearPercentIndicator(
                    //       width: MediaQuery.of(context).size.width * 0.75,
                    //       animation: true,
                    //       animateFromLastPercent: true,
                    //       lineHeight: 25.0,
                    //       animationDuration: 2500,
                    //       percent: percentValue,
                    //       barRadius: Radius.circular(30),
                    //       center: Text(
                    //         "${percentValue * 100}%",
                    //         style: GoogleFonts.mochiyPopOne(
                    //             fontSize: 18, color: Colors.white),
                    //       ),
                    //       linearStrokeCap: LinearStrokeCap.roundAll,
                    //       progressColor: percentValue < 0.5
                    //           ? Colors.yellow
                    //           : percentValue > 0.8
                    //               ? defaultButton
                    //               : Colors.green,
                    //     ),
                    //   ),
                    // ),
                    //   ]),
                    // );
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 30),
                      child: PageView.builder(
                          itemCount: questions.length,
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (int index) {
                            setState(() {
                              _currentPageIndex = index;
                            });
                            // showPercent();
                          },
                          itemBuilder: (context, index) {
                            double valueP = index / questions.length * 100;
                            return ListView(
                              children: [
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                SizedBox(
                                  height: 55,
                                  width: size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //points gotten
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.yellowAccent
                                                    .withOpacity(0.3)),
                                            child: Text(
                                              '$_score points',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 35, 0, 82)),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          usermodel.diamonds < 2
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    MySnack(
                                                        context,
                                                        'Buying of Diamonds coming soon',
                                                        Colors.deepPurple);
                                                  },
                                                  child: const Text(
                                                      'Buy Diamonds'))
                                              : GestureDetector(
                                                  onTap: usermodel.diamonds < 2
                                                      ? () => MySnack(
                                                          context,
                                                          'Low on Diamonds',
                                                          Colors.deepPurple)
                                                      : () {
                                                          showHint(diamonds);
                                                          setState(() {
                                                            answer = questions[
                                                                    questionIndex]
                                                                ['answer'];
                                                          });
                                                        },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Color(0xFFE040FB)
                                                            .withOpacity(0.3)),
                                                    child: Text(
                                                      '🔔Hint💎-2',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      35,
                                                                      0,
                                                                      82)),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),

                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.yellowAccent
                                                .withOpacity(0.3)),
                                        child: Text(
                                          '$time⏰',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 35, 0, 82)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: questions[index][''] != ''
                                      ? Text(
                                          'Section: ${questions[index]['section']}',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 15),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: BounceInUp(
                                    delay: Duration(milliseconds: 700),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: defaultButton,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 224, 224, 224),
                                              offset: Offset(4, 4),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                            BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(-4, -4),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                          ]),
                                      child: Center(
                                          child: Text(
                                        '${questions[index]['question']}',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                questions[index]['image'] != ''
                                    ? Container(
                                        height: 150,
                                        width: 200,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '${questions[index]['image']}'))),
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BounceInDown(
                                        delay: Duration(milliseconds: 550),
                                        child: Text(
                                          'Question ${index + 1}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        '${index + 1}/${questions.length}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                FadeInLeft(
                                  delay: Duration(milliseconds: 700),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: questions[index]['option']
                                        .entries
                                        .map<Widget>(
                                      (option) {
                                        return FadeIn(
                                          delay:
                                              const Duration(milliseconds: 300),
                                          child: Container(
                                            // height: 50,
                                            margin: const EdgeInsets.only(
                                                top: 10, left: 5, right: 5),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: lighBlue,
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     color: lighBg,
                                              //     offset: Offset(4, 4),
                                              //     blurRadius: 10,
                                              //     spreadRadius: 1,
                                              //   ),
                                              //   BoxShadow(
                                              //     color: defaultButton,
                                              //     offset: Offset(-4, -4),
                                              //     blurRadius: 10,
                                              //     spreadRadius: 1,
                                              //   ),
                                              // ]
                                            ),
                                            child: RadioListTile(
                                              title: Text(
                                                option.value,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              value: option.key,
                                              // groupValue: null,
                                              groupValue:
                                                  selectedOption, // question['answer'],
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedOption =
                                                      value as String;
                                                });
                                                _checkAnswer(selectedOption);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: LinearPercentIndicator(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    animation: true,
                                    animateFromLastPercent: true,
                                    lineHeight: 25.0,
                                    animationDuration: 2500,
                                    percent: index / questions.length,
                                    barRadius: Radius.circular(30),
                                    center: Text(
                                      "${valueP.toStringAsFixed(2)}%",
                                      style: GoogleFonts.mochiyPopOne(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor:
                                        index / questions.length < 0.5
                                            ? Colors.yellow
                                            : percentValue > 0.8
                                                ? defaultButton
                                                : Colors.green,
                                  ),
                                ),

                                _isLoaded
                                    ? SizedBox(
                                        width: _bannerAd!.size.width.toDouble(),
                                        height:
                                            _bannerAd!.size.height.toDouble(),
                                        child: AdWidget(ad: _bannerAd!),
                                      )
                                    : UnityBannerAd(
                                        placementId: 'Banner_Android',
                                        onLoad: (adUnitId) =>
                                            print('Banner loaded: $adUnitId'),
                                        onClick: (adUnitId) =>
                                            print('Banner clicked: $adUnitId'),
                                        onFailed: (adUnitId, error, message) =>
                                            print(
                                                'Banner Ad $adUnitId failed: $error $message'),
                                      ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '$answer',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ],
                            );
                          }),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error'),
                    );
                  } else {
                    return MyShrimmer();
                  }
                }));
  }
}
