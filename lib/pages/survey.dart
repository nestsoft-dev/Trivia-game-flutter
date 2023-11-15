import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitlabs_plugin/bitlabs_plugin.dart';

import '../firebase/firebase_functions.dart';
import '../model/user_model.dart';

class BitLabSurvey extends StatefulWidget {
  const BitLabSurvey({super.key});

  @override
  State<BitLabSurvey> createState() => _BitLabSurveyState();
}

class _BitLabSurveyState extends State<BitLabSurvey> {
  int UserPoints = 0;
  @override
  void initState() {
    BitlabsPlugin.instance.init(
        token: 'a0bff970-2a5e-4259-9036-2f07d0b8a1b6',
        userId: FirebaseAuth.instance.currentUser!.uid);

    BitlabsPlugin.instance.onRewarded((reward) {
      int newPoints = UserPoints + reward.toInt();
      FirebaseFun().uploadPoints(newPoints);
    });
    BitlabsPlugin.instance.show();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFun().getuserData(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> userData =
                  snapshot.data!.data() as Map<String, dynamic>;
              UserModel user = UserModel.fromMap(userData);
              UserPoints = user.point;
              return Center(
                child: ElevatedButton(
                    onPressed: () {
                      BitlabsPlugin.instance.show();
                    },
                    child: Text('Start Survey')),
              );
            } else if (snapshot.hasError) {
              return const Center();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
