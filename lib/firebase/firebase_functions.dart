import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/constant.dart';
import '../model/user_model.dart';
import '../screens/bottom_nav.dart';
import '../widgets/my_snack.dart';

class FirebaseFun extends ChangeNotifier {
  User? user;
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
          referralCode: referralCode,
          uid: '');

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
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      )
          .then((value) async {
        final String characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String code = '';
        final Random random = Random();

        for (int i = 0; i < 7; i++) {
          code += characters[random.nextInt(characters.length)];
        }
        UserModel userModel = UserModel(
            name: name,
            point: 0,
            diamonds: 10,
            userImage: imageUrl,
            email: email,
            referralCode: code,
            uid: _auth.currentUser!.uid);
        _auth.currentUser!.sendEmailVerification();
        await firebaseFirestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .set(userModel.toMap())
            .then((value) =>
                MySnack(context, 'Account Created, Login', Colors.green));
      });

      if (userCredential != null) {
        // UserModel userModel = UserModel(
        //     name: name,
        //     point: 0,
        //     diamonds: 10,
        //     userImage: imageUrl,
        //     email: email,
        //     referralCode: code,
        //     uid: _auth.currentUser!.uid);
        // UserCredential userCredential = await _auth
        //     .createUserWithEmailAndPassword(email: email, password: password);
        // await firebaseFirestore
        //     .collection('users')
        //     .doc(_auth.currentUser!.uid)
        //     .set(userModel.toMap())
        //     .then((value) {
        //   // Navigator.pushAndRemoveUntil(
        //   //     context,
        //   //     MaterialPageRoute(builder: (context) => BottomNav()),
        //   //     (route) => false);
        // });
        // User creation was successful
        User? user = userCredential.user;
        if (user != null) {
        } else {
          print("User is null");
          // Handle user being null
        }
      } else {
        print("UserCredential is null");
        // Handle userCredential being null
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        print("Error creating user: ${e.code} - ${e.message}");
        // Handle specific Firebase Authentication errors here
      } else {
        print("An unexpected error occurred: $e");
        // Handle other exceptions or errors here
      }
    }

//  catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(e.toString()),
//         backgroundColor: Colors.red,
//       ));
//     }
  }

  //login
  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
            (route) => false);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
    notifyListeners();
  }

  // Sign out
  Future<void> signOut() async {
    // await googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    try {
      _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e.toString());
    }
    notifyListeners();
  }

  //getData
  Stream<DocumentSnapshot> getuserData() {
    return firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .snapshots();
  }

  //upload purchased Diamonds
  Future<void> uploadPurchaseDiamond(int purchasedDiamonds) async {
    await firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({'diamonds': purchasedDiamonds});
    notifyListeners();
  }

  //delete acct
  Future<void> deleteUser(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();

      await firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .delete()
          .then((value) => MySnack(context, 'Account Deleted', Colors.green));
    } catch (e) {
      throw Exception(e.toString());
    }
    notifyListeners();
  }

  Future<void> scores(int points, int diamonds) async {
    await firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      'point': points,
      'diamonds': diamonds,
    });
  }
}
