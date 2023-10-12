import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/constant.dart';
import '../model/user_model.dart';

class FirebaseFun {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Sign in with Google
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserModel userModel =
          UserModel(name: '', point: 0, diamonds: 0, userImage: imageUrl);

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      await firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(userModel.toMap());
      final User? user = authResult.user;
      return user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
