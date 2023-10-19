import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/bottom_nav.dart';
import 'auth_gate.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    //AuthGate

    Future.delayed(Duration(milliseconds: 3000)).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthGate()),
          (route) => false);
//       if(firebaseAuth.currentUser!=null){
// Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => BottomNav()),
//             (route) => false);
//       }else{
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => OnBoardingScreen()),
//             (route) => false);
//       }
    });
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
              begin: Alignment.bottomRight)),
      child: Center(
        child: Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
