// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter/material.dart';
import 'package:onepref/onepref.dart';

import '../firebase/firebase_functions.dart';
import 'my_snack.dart';

class BannerHome extends StatefulWidget {
  BannerHome({
    Key? key,
    required this.size,
    required this.diamonds,
    required this.points,
  }) : super(key: key);

  final Size size;
  final int diamonds;
  final int points;

  @override
  State<BannerHome> createState() => _BannerHomeState();
}

class _BannerHomeState extends State<BannerHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _streamSubscription!.dispose();
  }

  void creditUser(PurchaseDetails purchaseDetails) async {
    for (var product in storeProductIds) {
      if (product.id == purchaseDetails.productID) {
        int newDiamond = widget.diamonds + product.reward!;
        FirebaseFun().uploadPurchaseDiamond(newDiamond);
      }
    }
  }

  List<String> _kIds = <String>['diamond_10', 'diamond_30', 'diamond_60'];
  List<ProductId> storeProductIds = [
    ProductId(id: 'diamond_10', isConsumable: true, reward: 10),
    ProductId(id: 'diamond_30', isConsumable: true, reward: 30),
    ProductId(id: 'diamond_60', isConsumable: true, reward: 60),
    //ProductId(id: 'id', isConsumable: true, reward: 10),
  ];

  //show
  // showDiamonds() => showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //           height: MediaQuery.of(context).size.height * 0.25,
  //           width: MediaQuery.of(context).size.width,
  //           child:

  //            ListView.builder(
  //               itemCount: _products.length,
  //               itemBuilder: (context, index) {
  //                 return GestureDetector(
  //                   onTap: () {
  //                     iApEngine.handlePurchase(_products[index], storeProductIds);
  //                   },
  //                   child: ListTile(
  //                     title: Text('${_products[index].description}💎',
  //                         style: TextStyle(color: Colors.black)),
  //                     trailing: Text(_products[index].price,
  //                         style: TextStyle(color: Colors.black)),
  //                   ),
  //                 );
  //               }),
  //           );
  //     });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(13),
        width: widget.size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
                colors: [Colors.pink, Colors.pinkAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earned Points',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[350]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.points}',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.yellow),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diamonds',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[350]),
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.diamonds < 1
                    ? ElevatedButton(
                        onPressed: () {
                          // showDiamonds();

                          MySnack(context, "Buying Diamonds Coming soon",
                              Colors.green);
                        },
                        child: const Text('Buy Diamonds'))
                    : Text(
                        '💎${widget.diamonds}',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
