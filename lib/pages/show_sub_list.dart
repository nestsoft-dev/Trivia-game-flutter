import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:onepref/onepref.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import '../firebase/firebase_functions.dart';

class ShowSubist extends StatefulWidget {
  const ShowSubist({super.key});

  @override
  State<ShowSubist> createState() => _ShowSubistState();
}

class _ShowSubistState extends State<ShowSubist> {
  List<ProductId> storeProductIds = [
    ProductId(id: 'diamond_10', isConsumable: true, reward: 10),
    ProductId(id: 'diamond_30', isConsumable: true, reward: 30),
    ProductId(id: 'diamond_60', isConsumable: true, reward: 60),
  ];

  final List<ProductDetails> products = [];
  IApEngine iApEngine = IApEngine();

  void getProducts() async {
    await iApEngine.getIsAvailable().then((value) async {
      if (value) {
        await iApEngine.queryProducts(storeProductIds).then((res) {
          setState(() {
            products.addAll(res.productDetails);
          });
        });
      }
    });
  }

  initProcess() {
    iApEngine.inAppPurchase.purchaseStream.listen((event) {
      listenPurchases(event);
    });
    getProducts();
  }

  void listenPurchases(List<PurchaseDetails> event) async {
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
        giveUserDiamonds(purchase);
      }
    }
  }

  giveUserDiamonds(PurchaseDetails purchasedetails) {
    for (var product in storeProductIds) {
      if (product.id == purchasedetails.productID) {
        FirebaseFun().uploadPurchaseDiamond(product.reward!);
      }
    }
  }

  purchase(ProductDetails productDetails) {
    iApEngine.handlePurchase(productDetails, storeProductIds);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initProcess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Purchase Diamond'),
      ),
      body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  print('${products[index].price}');
                  purchase(products[index]);
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                      '${products[index].description}',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    trailing: Text(
                      '${products[index].price}',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              )),
    );
  }
}
