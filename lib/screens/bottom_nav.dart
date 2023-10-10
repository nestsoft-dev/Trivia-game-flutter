import 'package:flutter/material.dart';
import 'package:trival_game/screens/chats.dart';
import 'package:trival_game/screens/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/constant.dart';
import 'chart.dart';
import 'profile.dart';
import 'search.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> _screen = [
    const HomePage(),
    const SearchPage(),
    const MyChats(),
    const Charts(),
    const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTap,
          elevation: 0,
          selectedItemColor: defaultButton,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.homeUser), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.message), label: 'Chats'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.moneyCheck), label: 'Payment'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.userAstronaut), label: 'Profile'),
          ]),
    );
  }
}
