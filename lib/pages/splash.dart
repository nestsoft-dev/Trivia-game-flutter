import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/bottom_nav.dart';
import 'auth_gate.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  final double _containerSize = 0;

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
        child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 250),
            duration: const Duration(milliseconds: 2000),
            builder: (context, double size, child) {
              return Image.asset(
                'assets/altris_icon.png',
                height: size,
                width: size,
              );
            }),
      ),
    );
  }
}
