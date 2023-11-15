// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:trival_game/firebase/firebase_functions.dart';

import '../model/user_model.dart';

class WithdrawalScreen extends StatefulWidget {
  final int points;
  final String paymentType;
  const WithdrawalScreen({
    Key? key,
    required this.points,
    required this.paymentType,
  }) : super(key: key);

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder(
          stream: FirebaseFun().getuserData(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> userData =
                  snapshot.data!.data() as Map<String, dynamic>;
              UserModel userModel = UserModel.fromMap(userData);
              return Column(
                children: [],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
