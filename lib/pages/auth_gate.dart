import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trival_game/pages/register.dart';
import 'package:rxdart/rxdart.dart';
import '../screens/bottom_nav.dart';
import '../widgets/my_shrimmer.dart';
import 'login.dart';
import 'onboarding_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Stream<User?> checkAuth() {
    Stream<User?> _auth = FirebaseAuth.instance.authStateChanges();
    return _auth.delay(const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: checkAuth(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const BottomNav();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred'),
            );
          } else {
            return const OnBoardingScreen();
          }
        });
  }
}
