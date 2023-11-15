// import 'package:in_app_purchase/in_app_purchase.dart';

import 'dart:io';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:onepref/onepref.dart';

import '../firebase/firebase_functions.dart';

class BuyDiamonds {
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
          print(res.productDetails.length);
          print(res.productDetails.length);
          print(res.productDetails.length);
          print(res.productDetails.length);
          products.addAll(res.productDetails);
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
}



// class PurchaseDiamonds{
//    final InAppPurchase _inAppPurchase = InAppPurchase.instance;
// //  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
//   late List<ProductDetails> _products;

//    Future<void> _initialize() async {
//     final available = await _connection.isAvailable();
//     if (!available) {
//       // In-app purchases are not available on this device
//       return;
//     }

//     final products = await _connection.queryProductDetails({'your_product_id'});
//     if (products.isNotEmpty) {
      
//         _products = products;
    
//     }
//   }

//   Future<void> _buyProduct(String productId) async {
//     final PurchaseParam purchaseParam = PurchaseParam(
//       productDetails:
//           _products.firstWhere((product) => product.id == productId),
//     );

//     await _connection.buyConsumable(
//       purchaseParam: purchaseParam,
//       autoConsume: true, // Set to true for consumables
//     );
//   }
// }