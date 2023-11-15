import 'package:flutter/material.dart';

final String API_KEY = 'ALOC-de08837978fd45c30861';
String amazon = 'assets/amazon.png';
String apple = 'assets/apple.jpg';
String paypal = 'assets/paypal.png';

final Color defaultButton = Colors.deepPurple;
final Color lighBg = Color.fromARGB(143, 229, 213, 255);
final Color lighBlue = Color.fromARGB(255, 1, 27, 255);
final Color darkblue = Color.fromARGB(255, 0, 5, 70);
final Color lighyellow = Colors.yellow;
final String imageUrl =
    'https://firebasestorage.googleapis.com/v0/b/game-trivial.appspot.com/o/netsoft%20logo-01.jpg?alt=media&token=14db4774-1c1a-4e69-8d29-87be1e397747';

const String pollfish = 'e8797052-eed2-4bcb-a486-fbb72d6947f2';
List<Map<String, dynamic>> onBoardingList = [
  {
    'title': 'E-Learning Quiz',
    'image': 'assets/quiz.png',
    'des': 'Learn by practicing various Subjects and Categories Quiz'
  },
  {
    'title': 'Invite A Friend Over',
    'image': 'assets/share.png',
    'des': 'Share with friends and get Free 💎Diamonds'
  },
  {
    'title': 'All subjects Available',
    'image': 'assets/subjects.png',
    'des': 'Choose quiz from Various field of your choice'
  },
  {
    'title': 'Get Paid through PayPal',
    'image': 'assets/paypal.png',
    'des': 'Get more points that can be changed to paypal funds or GiftCards'
  },
  {
    'title': 'Chat with friends',
    'image': 'assets/chat.png',
    'des': 'Chat with various players online and make friends'
  },
  {
    'title': 'Learn With Friends',
    'image': 'assets/learnwithfrnd.png',
    'des': 'Get paid while you have fun with friends'
  },
];

List<Map<String, dynamic>> rewardsList = [
  // {'cardName': 'Amazon', 'amount': 5, 'image': amazon, 'points': 59120},
  {'cardName': 'PayPal', 'amount': 0.01, 'image': paypal, 'points': 1125},
  {'cardName': 'PayPal', 'amount': 0.05, 'image': paypal, 'points': 5550},
  {'cardName': 'PayPal', 'amount': 0.10, 'image': paypal, 'points': 11125},
  {'cardName': 'PayPal', 'amount': 0.15, 'image': paypal, 'points': 15125},
  {'cardName': 'PayPal', 'amount': 0.20, 'image': paypal, 'points': 20250},
  {'cardName': 'PayPal', 'amount': 0.25, 'image': paypal, 'points': 25500},
  {'cardName': 'PayPal', 'amount': 0.30, 'image': paypal, 'points': 30125},
  {'cardName': 'PayPal', 'amount': 0.35, 'image': paypal, 'points': 35250},
  {'cardName': 'PayPal', 'amount': 0.40, 'image': paypal, 'points': 70500},
  // {'cardName': 'Apple', 'amount': 25, 'image': apple, 'points': 72350},
  // {'cardName': 'Amazon', 'amount': 15, 'image': amazon, 'points': 57260},
  // {'cardName': 'PayPal', 'amount': 30, 'image': paypal, 'points': 95150},
  // {'cardName': 'Apple', 'amount': 40, 'image': apple, 'points': 151350},
  // {'cardName': 'Amazon', 'amount': 50, 'image': amazon, 'points': 85328},
];
