import 'package:flutter/material.dart';

final String API_KEY = 'ALOC-de08837978fd45c30861';

final Color defaultButton = Colors.deepPurple;
final Color lighBg = Color.fromARGB(143, 229, 213, 255);
final Color lighBlue = Color.fromARGB(255, 1, 27, 255);
final Color darkblue = Color.fromARGB(255, 0, 5, 70);
final Color lighyellow = Colors.yellow;
final String imageUrl =
    'https://firebasestorage.googleapis.com/v0/b/my-bch-farm.appspot.com/o/cj.jpg?alt=media&token=bece50b2-1cfe-41ca-94d5-17a0a916ae4f';

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
