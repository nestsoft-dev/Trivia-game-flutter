import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trival_game/pages/register.dart';

import '../screens/bottom_nav.dart';
import '../widgets/my_shrimmer.dart';
import 'login.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const BottomNav();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred'),
            );
          } else {
            return const RegisterPage();
          }
        });
  }
}
