// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter/material.dart';
import 'package:onepref/onepref.dart';

import '../firebase/firebase_functions.dart';

class BannerHome extends StatefulWidget {
  BannerHome({
    Key? key,
    required this.size,
    required this.diamonds,
    required this.points,
  }) : super(key: key);

  final Size size;
  final double diamonds;
  final double points;

  @override
  State<BannerHome> createState() => _BannerHomeState();
}

class _BannerHomeState extends State<BannerHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
    iApEngine.inAppPurchase.purchaseStream.listen((event) {
      listenPurchases(event);
    });
  }

  Future<void> listenPurchases(List<PurchaseDetails> event) async {
    for (PurchaseDetails purchase in event) {
      if (purchase.status == PurchaseStatus.restored ||
          purchase.status == PurchaseStatus.purchased) {
        if (Platform.isAndroid &&
            iApEngine
                .getProductIdsOnly(storeProductIds)
                .contains(purchase.productID)) {
          final InAppPurchaseAndroidPlatformAddition androidPlatformAddition =
              iApEngine.inAppPurchase.getPlatformAddition();
        }
        if (purchase.pendingCompletePurchase) {
          await iApEngine.inAppPurchase.completePurchase(purchase);
        }
        //credit user
        creditUser(purchase);
      }
    }
  }

  void creditUser(PurchaseDetails purchaseDetails) async {
    //FirebaseFun().
    for (var product in storeProductIds) {
      if (product.id == purchaseDetails.productID) {
        double newDiamond = widget.diamonds + product.reward!;
        FirebaseFun().uploadPurchaseDiamond(newDiamond);
      }
    }
  }

  final List<ProductDetails> _products = [];

  IApEngine iApEngine = IApEngine();

  List<ProductId> storeProductIds = [
    ProductId(id: 'id', isConsumable: true, reward: 10),
    ProductId(id: 'id', isConsumable: true, reward: 10),
    ProductId(id: 'id', isConsumable: true, reward: 10),
    ProductId(id: 'id', isConsumable: true, reward: 10),
  ];

  void getProducts() async {
    await iApEngine.getIsAvailable().then((value) async {
      if (value) {
        await iApEngine.queryProducts(storeProductIds).then((response) {
          setState(() {
            _products.addAll(response.productDetails);
          });
        });
      }
    });
  }

  //show
  showDiamonds() => showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    iApEngine.handlePurchase(_products[index], storeProductIds);
                  },
                  child: ListTile(
                    title: Text('${_products[index].description}💎'),
                    trailing: Text(_products[index].price),
                  ),
                );
              }),
        );
      });
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
                          showDiamonds();
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
