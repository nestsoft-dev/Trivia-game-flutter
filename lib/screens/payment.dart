import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/constant.dart';

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
        title: Text('Redeem Points'),
      ),
      body: Stack(
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
          
        ],
      ),
    );
  }
}
