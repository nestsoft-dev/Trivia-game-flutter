import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/constant.dart';
import '../model/user_model.dart';
import '../widgets/my_snack.dart';

class FirebaseFun {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String referralCode = "";

  // Generate a random alphanumeric code of a specified length
  String generateRandomCode(int length) {
    final String characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String code = '';
    final Random random = Random();

    for (int i = 0; i < length; i++) {
      code += characters[random.nextInt(characters.length)];
    }

    return code;
  }

  void generateReferralCode() {
    // Generate a unique referral code for the user
    referralCode = generateRandomCode(6);
  }

  // Sign in with Google
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      generateReferralCode();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserModel userModel = UserModel(
          name: '',
          point: 0,
          diamonds: 0,
          userImage: imageUrl,
          email: '',
          referralCode: referralCode);

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

  //register
  Future<void> register(
    
      BuildContext context, String name, String email, String password) async {
    try {
      generateReferralCode();
      UserModel userModel = UserModel(
          name: name,
          point: 0,
          diamonds: 0,
          userImage: imageUrl,
          email: email,
          referralCode: referralCode);
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async => firebaseFirestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .set(userModel.toMap()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  //login
  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Sign out
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }

  //getData
  Stream<DocumentSnapshot> getuserData() {
    return firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .snapshots();
  }

  //upload purchased Diamonds
  Future<void> uploadPurchaseDiamond(double purchasedDiamonds) async {
    await firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({'diamonds': purchasedDiamonds});
  }

  //delete acct
  Future<void> deleteUser(BuildContext context) async {
    await _auth.currentUser!.delete();

    await firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .delete()
        .then((value) => MySnack(context, 'Account Deleted', Colors.green));
  }
}
