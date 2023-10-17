import 'package:flutter/material.dart';
import 'package:trival_game/screens/chats.dart';
import 'package:trival_game/screens/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../constants/constant.dart';
import 'payment.dart';
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

  List<Widget> _screen = const [
    const HomePage(),
    const SearchPage(),
    const MyChats(),
    const RedeemPoints(),
    const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
              selectedIndex: _currentIndex,
              onTabChange: onTap,
              backgroundColor: Colors.white,
              duration: const Duration(milliseconds: 900),
              rippleColor: Color.fromARGB(
                  255, 136, 93, 255), // tab button ripple color when pressed
              tabBorderRadius: 15,
              curve: Curves.easeOutExpo, // tab animation curves
              gap: 15, // the tab button gap between icon and text
              color: Colors.grey[350], // unselected icon color
              activeColor: Colors.purple, // selected icon and text color
              iconSize: 24, // tab button icon size
              tabBackgroundColor: Colors.purple
                  .withOpacity(0.1), // selected tab background color
              padding: const EdgeInsets.all(13), // navigation bar padding
              tabs: const [
                GButton(icon: FontAwesomeIcons.homeUser, text: 'Home'),
                GButton(icon: FontAwesomeIcons.search, text: 'Search'),
                GButton(icon: FontAwesomeIcons.message, text: 'Chats'),
                GButton(
                    icon: FontAwesomeIcons.moneyCheckDollar, text: 'Payment'),
                GButton(icon: FontAwesomeIcons.userAstronaut, text: 'Profile')
              ]),
        ),
      ),
     
    );
  }
}
