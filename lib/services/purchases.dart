
// import 'package:in_app_purchase/in_app_purchase.dart';

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