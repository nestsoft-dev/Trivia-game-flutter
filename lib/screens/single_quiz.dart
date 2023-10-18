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
import '../constants/constant.dart';
import '../model/question_model.dart';
import '../model/user_model.dart';
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    timer?.cancel();

    // controller.dispose();
  }

  List<String> yearList = [
    '2007',
    '2008',
    '2009',
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018'
  ];

  List<dynamic> questionList = [];
  bool _isLoading = true;

  Future<void> getQuestions(String subject) async {
    Uri url = Uri.parse(
        'https://questions.aloc.com.ng/api/v2/q/50?subject=english&year=2016');

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
            questionList = mydata['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            var mydata = jsonDecode(value.body);
            questionList = mydata['data'];
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
  double _score = 0;
  bool ispressed = false;
  double balance = 0;
  int points = 0;
  int diamonds = 0;

  void _checkAnswer(String selectedOption) {
    if (questionList[_currentPageIndex]['answer'] == selectedOption) {
      print('correct');
      setState(() {
        _score += 10;
      });
      print('correct $_score');
      print('${questionList[_currentPageIndex]['answer']}');
    }
    _goToNextQuestion();
  }

  Future<void> _goToNextQuestion() async {
    print('next screen');
    if (_currentPageIndex < questionList.length - 1) {
      setState(() {
        _currentPageIndex++;
      });
    } else {
      // uploadReward(points, money, wonMoney, _score);
      // Quiz completed, show result or navigate to next page
      // You can customize this part based on your app's logic

      //TODO show result
      // _rewardedAd!.show(
      //     onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      //   // Reward the user for watching an ad.
      // });
      // await firebaseFunction.uploadOrUpdateSubjectScore(
      //     widget.subject[0], _score);
      // await firebaseFunction
      //     .updateResult(
      //         widget.subject[0], balance, points, money, _score, context)
      //     .whenComplete(() {
      //   showResult();
      // });
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
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => RewardsScreen()),
            (route) => false);

        timer?.cancel();
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getQuestions(widget.subject);
    startTimer();
    getProducts();
    iApEngine.inAppPurchase.purchaseStream.listen((event) {
      listenPurchases(event);
    });
  }

  Future<void> listenPurchases(List<PurchaseDetails> event) async {
    for (PurchaseDetails purchase in event) {
      if (purchase.status == PurchaseStatus.restored ||
          purchase.status == PurchaseStatus.purchased) {
        if (Platform.isAndroid &&
            iApEngine
                .getProductIdsOnly(storeProductIds)
                .contains(purchase.productID)) {
          final InAppPurchaseAndroidPlatformAddition androidPlatformAddition =
              iApEngine.inAppPurchase.getPlatformAddition();
        }
        if (purchase.pendingCompletePurchase) {
          await iApEngine.inAppPurchase.completePurchase(purchase);
        }
        //credit user
        creditUser(purchase);
      }
    }
  }

  void creditUser(PurchaseDetails purchaseDetails) async {
    for (var product in storeProductIds) {
      if (product.id == purchaseDetails.productID) {
        int newDiamond = diamonds + product.reward!;
        FirebaseFun().uploadPurchaseDiamond(newDiamond);
      }
    }
  }

  final List<ProductDetails> _products = [];

  IApEngine iApEngine = IApEngine();

  List<ProductId> storeProductIds = [
    ProductId(id: 'diamond_10', isConsumable: true, reward: 10),
    ProductId(id: 'diamond_30', isConsumable: true, reward: 30),
    ProductId(id: 'diamond_60', isConsumable: true, reward: 60),
    //ProductId(id: 'id', isConsumable: true, reward: 10),
  ];

  void getProducts() async {
    debugPrint(
      'The mann',
    );
    await iApEngine.getIsAvailable().then((value) async {
      if (value) {
        await iApEngine.queryProducts(storeProductIds).then((response) {
          setState(() {
            _products.addAll(response.productDetails);
          });
          debugPrint(_products.length.toString());
          debugPrint(
            'The mann',
          );
        });
      }
    }).then((value) => print('hello'));
  }

  //show
  showDiamonds() => showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    iApEngine.handlePurchase(_products[index], storeProductIds);
                  },
                  child: ListTile(
                    title: Text('${_products[index].description}💎',
                        style: TextStyle(color: Colors.black)),
                    trailing: Text(_products[index].price,
                        style: TextStyle(color: Colors.black)),
                  ),
                );
              }),
        );
      });

  double percentValue = 0.0;

  final List<Map<String, dynamic>> questions = [
    {
      "id": 517,
      "question": "  understandable ",
      "option": {
        "a": "unDERstandable",
        "b": "understandABLE",
        "c": "UNderstandable ",
        "d": "underSTANDable.",
        "e": "underSTANDable."
      },
      "section":
          "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
      "image": "",
      "answer": "d",
      "solution": "",
      "examtype": "utme",
      "examyear": "2009",
      "questionNub": null,
      "hasPassage": 0,
      "category": "others"
    },
    {
      "id": 391,
      "question": "His <i>kind-hearted</i> master bought him a motorcycle",
      "option": {
        "a": " stingy   ",
        "b": "generous    ",
        "c": " shrewd ",
        "d": "angry.",
        "e": "angry."
      },
      "section":
          "choose the option opposite in meaning to the word or phrase in italics.",
      "image": "",
      "answer": "d",
      "solution": "",
      "examtype": "utme",
      "examyear": "2008",
      "questionNub": null,
      "hasPassage": 0,
      "category": "others"
    },
    {
      "id": 517,
      "question": "  understandable ",
      "option": {
        "a": "unDERstandable",
        "b": "understandABLE",
        "c": "UNderstandable ",
        "d": "underSTANDable.",
        "e": "underSTANDable."
      },
      "section":
          "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
      "image": "",
      "answer": "d",
      "solution": "",
      "examtype": "utme",
      "examyear": "2009",
      "questionNub": null,
      "hasPassage": 0,
      "category": "others"
    },
    {
      "id": 517,
      "question": "  understandable ",
      "option": {
        "a": "unDERstandable",
        "b": "understandABLE",
        "c": "UNderstandable ",
        "d": "underSTANDable.",
        "e": "underSTANDable."
      },
      "section":
          "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
      "image": "",
      "answer": "d",
      "solution": "",
      "examtype": "utme",
      "examyear": "2009",
      "questionNub": null,
      "hasPassage": 0,
      "category": "others"
    },
    {
      "id": 517,
      "question": "  understandable ",
      "option": {
        "a": "unDERstandable",
        "b": "understandABLE",
        "c": "UNderstandable ",
        "d": "underSTANDable.",
        "e": "underSTANDable."
      },
      "section":
          "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
      "image": "",
      "answer": "d",
      "solution": "",
      "examtype": "utme",
      "examyear": "2009",
      "questionNub": null,
      "hasPassage": 0,
      "category": "others"
    },
    {
      "id": 517,
      "question": "  understandable ",
      "option": {
        "a": "unDERstandable",
        "b": "understandABLE",
        "c": "UNderstandable ",
        "d": "underSTANDable.",
        "e": "underSTANDable."
      },
      "section":
          "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
      "image": "",
      "answer": "d",
      "solution": "",
      "examtype": "utme",
      "examyear": "2009",
      "questionNub": null,
      "hasPassage": 0,
      "category": "others"
    },
    {
      "id": 517,
      "question": "  understandable ",
      "option": {
        "a": "unDERstandable",
        "b": "understandABLE",
        "c": "UNderstandable ",
        "d": "underSTANDable.",
        "e": "underSTANDable."
      },
      "section":
          "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
      "image": "",
      "answer": "d",
      "solution": "",
      "examtype": "utme",
      "examyear": "2009",
      "questionNub": null,
      "hasPassage": 0,
      "category": "others"
    },
    {
      "id": 517,
      "question": "  understandable ",
      "option": {
        "a": "unDERstandable",
        "b": "understandABLE",
        "c": "UNderstandable ",
        "d": "underSTANDable.",
        "e": "underSTANDable."
      },
      "section":
          "choose the appropriate stress pattern from the options. The syllables are written in capital letters.",
      "image": "",
      "answer": "d",
      "solution": "",
      "examtype": "utme",
      "examyear": "2009",
      "questionNub": null,
      "hasPassage": 0,
      "category": "others"
    },
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

  double hint = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: time < 5
            ? FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.video_call,
                  color: Colors.yellow[700],
                ),
              )
            : SizedBox.shrink(),
        backgroundColor: Colors.blue,
        body: StreamBuilder(
            stream: FirebaseFun().getuserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                UserModel usermodel = UserModel.fromMap(data);
                diamonds = usermodel.diamonds;

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          Colors.yellowAccent.withOpacity(0.3)),
                                  child: Text(
                                    '$_score points',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 35, 0, 82)),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                usermodel.diamonds < 2
                                    ? ElevatedButton(
                                        onPressed: () {
                                          // showDiamonds();
                                          showDiamonds();
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
                                  color: Colors.yellowAccent.withOpacity(0.3)),
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

                        /*
               _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              :
              */
                      ),
                    ),
                    Container(
                      height: size.height * 0.65,
                      child: CardSwiper(
                          controller: controller,
                          isLoop: false,
                          onEnd: () {
                            controller.dispose();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RewardsScreen()),
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
                            final question = questions[index];
                            return QuizCard(
                              question: question,
                              currentIndex: index,
                            );
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
