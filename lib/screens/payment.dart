import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:trival_game/firebase/firebase_functions.dart';
import 'package:trival_game/model/user_model.dart';

import '../constants/constant.dart';
import '../widgets/my_shrimmer.dart';
import '../widgets/my_snack.dart';

class RedeemPoints extends StatefulWidget {
  const RedeemPoints({super.key});

  @override
  State<RedeemPoints> createState() => _RedeemPointsState();
}

class _RedeemPointsState extends State<RedeemPoints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text('Redeem Points'),
        ),
        body: StreamBuilder(
            stream: FirebaseFun().getuserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> userData =
                    snapshot.data!.data() as Map<String, dynamic>;
                UserModel userModel = UserModel.fromMap(userData);
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment(1, -1),
                      child: Container(
                        height: 250,
                        width: 230,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lighBlue.withOpacity(0.8),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(1, 0),
                      child: Container(
                        height: 250,
                        width: 230,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow[700]!.withOpacity(0.8),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-1, 1),
                      child: Container(
                        height: 250,
                        width: 230,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: darkblue.withOpacity(0.8),
                        ),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.black.withOpacity(0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5),
                          itemCount: rewardsList.length,
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: rewardsList[index]['points'] <
                                        userModel.diamonds
                                    ? () {}
                                    : () => MySnack(
                                        context, 'Low points', Colors.red),
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[350],
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12)),
                                        child: Image.asset(
                                          rewardsList[index]['image'],
                                          height: 120,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                            '${rewardsList[index]['cardName']} GiftCard'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                            '${rewardsList[index]['amount']}\$',
                                            style: GoogleFonts.mochiyPopOne(
                                                fontSize: 16)),
                                      ),
                                      LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.47,
                                        animation: true,
                                        animateFromLastPercent: true,
                                        lineHeight: 25.0,
                                        animationDuration: 2500,
                                        percent: userModel.point /
                                            rewardsList[index]['points'],
                                        barRadius: Radius.circular(30),
                                        center: Text(
                                          "${userModel.point / rewardsList[index]['points'] * 100}%",
                                          style: GoogleFonts.mochiyPopOne(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        linearStrokeCap:
                                            LinearStrokeCap.roundAll,
                                        progressColor: userModel.point /
                                                    rewardsList[index]
                                                        ['points'] <
                                                0.5
                                            ? Colors.yellow
                                            : userModel.point /
                                                        rewardsList[index]
                                                            ['points'] >
                                                    0.8
                                                ? defaultButton
                                                : Colors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                    )

                    // Center(
                    //   child: Text(
                    //     'Google play giftCards\nAmazon Giftcard\nPaypal payments are coming Soon',
                    //     style: GoogleFonts.mochiyPopPOne(
                    //         fontWeight: FontWeight.w500,
                    //         fontSize: 18,
                    //         color: Color.fromARGB(255, 35, 0, 82)),
                    //   ),
                    // )
                  ],
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error Occured'),
                );
              } else {
                return const MyShrimmer();
              }
            }));
  }
}
