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
  {'cardName': 'Amazon', 'amount': 10, 'image': amazon, 'points': 5120},
  {'cardName': 'PayPal', 'amount': 5, 'image': paypal, 'points': 7350},
  {'cardName': 'Apple', 'amount': 25, 'image': apple, 'points': 32350},
  {'cardName': 'Amazon', 'amount': 15, 'image': amazon, 'points': 17260},
  {'cardName': 'PayPal', 'amount': 30, 'image': paypal, 'points': 35150},
  {'cardName': 'Apple', 'amount': 40, 'image': apple, 'points': 51350},
  {'cardName': 'Amazon', 'amount': 50, 'image': amazon, 'points': 55328},

];
