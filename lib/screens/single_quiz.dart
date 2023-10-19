// ignore_for_file: public_member_api_docs, sort_constructors_first, dead_code_catch_following_catch
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    timer?.cancel();
  }

  bool _isLoading = true;

  Future<void> getQuestions() async {
    Uri url = Uri.parse(
        'https://questions.aloc.com.ng/api/v2/q/50?subject=${widget.subject}');

    try {
      var response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'AccessToken': API_KEY
      }).then((value) {
        if (value.statusCode == 200) {
          QuestionModel questionModel =
              QuestionModel.fromJson(jsonDecode(value.body));
          var mydata = jsonDecode(value.body);
          debugPrint('My question Model $questionModel');
          setState(() {
            questions = mydata['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            var mydata = jsonDecode(value.body);
            questions = mydata['data'];
            _isLoading = false;
          });
          debugPrint(value.toString());
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint(e.toString());
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } on SocketException catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
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
      print('correct');
      setState(() {
        _score += 10;
      });
      print('correct $_score');
      print('${questions[_currentPageIndex]['answer']}');
    }
    _goToNextQuestion();
  }

  Future<void> _goToNextQuestion() async {
    print('next screen');
    if (_currentPageIndex < questions.length - 1) {
      setState(() {
        _currentPageIndex++;
      });
      controller.swipe();
    } else {
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
    startTimer();
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

  List<Map<String, dynamic>> questions = [
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

  double hint = -2;

  showHint(int hint, int hintDia) async {
    int newD = hintDia - hint;
    await FirebaseFun().uploadPurchaseDiamond(newD);
  }
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
                onPressed: () async {
                  UnityAds.showVideoAd(
                    placementId: 'Rewarded_Android',
                    onComplete: (placementId) {
                      setState(() {
                        time += 3;
                      });
                    },
                    onFailed: (placementId, error, message) =>
                        print('Video Ad $placementId failed: $error $message'),
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

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SizedBox(
                            height: 55,
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            color:
                                                Color.fromARGB(255, 35, 0, 82)),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    usermodel.diamonds < 2
                                        ? ElevatedButton(
                                            onPressed: () {
                                              // showpurchaseDiamond
                                            },
                                            child: const Text('Buy Diamonds'))
                                        : Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.purpleAccent
                                                    .withOpacity(0.3)),
                                            child: Text(
                                              '🔔Hint💎-2',
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

                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          Colors.yellowAccent.withOpacity(0.3)),
                                  child: Text(
                                    '$time ⏰',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 35, 0, 82)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.65,
                          child: CardSwiper(
                              controller: controller,
                              isLoop: false,
                              onEnd: () {
                                MyAds().showInter();

                                controller.dispose();
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
                              },
                              initialIndex: 0,
                              cardsCount: questions.length,
                              onSwipe: _onSwipe,
                              onUndo: _onUndo,
                              numberOfCardsDisplayed: 3,
                              backCardOffset: const Offset(40, 40),
                              padding: const EdgeInsets.all(24.0),
                              cardBuilder: (
                                context,
                                index,
                                horizontalThresholdPercentage,
                                verticalThresholdPercentage,
                              ) {
                                Map<String, dynamic> question =
                                    questions[index];

                                return Card(
                                  margin: EdgeInsets.all(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(question['question']),
                                        SizedBox(height: 16),
                                        ...question['option']
                                            .entries
                                            .map((entry) {
                                          final optionKey = entry.key;
                                          final optionValue = entry.value;
                                          return ListTile(
                                            title: Text(optionValue),
                                            leading: Radio(
                                                value: optionKey,
                                                groupValue:
                                                    selectedOption, // question['answer'],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedOption =
                                                        value as String;
                                                  });
                                                }),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                );
                                // return QuizCard(
                                //   question: question,
                                //   currentIndex: index,
                                // );
                              }),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        //show progress of the question
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Flexible(
                            child: LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width * 0.75,
                              animation: true,
                              animateFromLastPercent: true,
                              lineHeight: 25.0,
                              animationDuration: 2500,
                              percent: percentValue,
                              barRadius: Radius.circular(30),
                              center: Text(
                                "${percentValue * 100}%",
                                style: GoogleFonts.mochiyPopOne(
                                    fontSize: 18, color: Colors.white),
                              ),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: percentValue < 0.5
                                  ? Colors.yellow
                                  : percentValue > 0.8
                                      ? defaultButton
                                      : Colors.green,
                            ),
                          ),
                        ),
                      ]),
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
