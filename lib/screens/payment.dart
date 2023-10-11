import 'package:flutter/material.dart';

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
    );
  }
}
