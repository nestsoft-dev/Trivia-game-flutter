// ignore_for_file: public_member_api_docs, sort_constructors_first, dead_code_catch_following_catch
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/constant.dart';
import '../model/question_model.dart';
import '../widgets/quiz_card.dart';

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
  PageController _pageController = PageController(
    initialPage: 0,
  );
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    controller.dispose();
    _pageController.dispose();
  }

  int _currentPage = 0;
  int pageIndex = 0;

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
    print(url);
    try {
      var response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'AccessToken': API_KEY
      }).then((value) {
        if (value.statusCode == 200) {
          var mydata = jsonDecode(value.body);
          debugPrint(mydata.toString());
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
  double points = 0;

  void _checkAnswer(String selectedOption) {
    if (questionList[_currentPageIndex]['answer'] == selectedOption) {
      print('correct');
      setState(() {
        _score++;
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
      double money = _score * 0.15;
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
        }
      } else if (time == 0) {
        double money = _score * 0.25;
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
  }

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

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: ListView(children: [
        SizedBox(
          height: 35,
          width: size.width,
          // child: SmoothPageIndicator(
          //     controller: controller.,
          //     count: 40,
          //     effect: const ExpandingDotsEffect(
          //       // dotColor: Colors.grey[200],
          //       dotHeight: 10,
          //       // dotWidth: 5,
          //       activeDotColor: Colors.white,
          //     ),
          //     onDotClicked: (index) {}),

          /*
           _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :
          */
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: size.height * 0.65,
            child: Expanded(
              child: CardSwiper(
                  controller: controller,
                  isLoop: false,
                  onEnd: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('last page')));
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
                    return QuizCard(question: question);
                  }),
              //time
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Center(
          child: SizedBox(
            height: 150,
            width: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: time / 15,
                  strokeWidth: 12,
                  color: Color.fromARGB(255, 227, 253, 251),
                  backgroundColor: Colors.green,
                ),
                Center(
                  child: Text(
                    '$time',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 80,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
