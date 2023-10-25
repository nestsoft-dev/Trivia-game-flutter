import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class MyAds {
  initAds() async {
  await UnityAds.init(
    gameId: '5376898',
    testMode: false,
    onComplete: () {
      MyAds().loadAdsInter();
      MyAds().loadAdsReward();

      print('Ads is Loaded\n\n\n\nLoaded');
    },
    onFailed: (error, message) =>
        print('Initialization Failed: $error $message \n\n\n failed'),
  );
  }

  loadAdsInter() async {
    UnityAds.load(
      placementId: 'Interstitial_Android',
      onComplete: (adUnitId) {},
      onFailed: (adUnitId, error, message) =>
          print('Interstitial Ad Load Failed $adUnitId: $error $message'),
    );
  }

  loadAdsReward() async {
    UnityAds.load(
      placementId: 'Rewarded_Android',
      onComplete: (adUnitId) {
        print('Rewarded Ad Load Complete $adUnitId');
      },
      onFailed: (adUnitId, error, message) =>
          print('Rewarded Ad Load Failed $adUnitId: $error $message'),
    );
  }

  showInter() {
     UnityAds.showVideoAd(
      placementId: 'Interstitial_Android',
      onFailed: (adUnitId, error, message) =>
        loadAdsInter(),
      onStart: (adUnitId) => loadAdsInter(),
      onClick: (adUnitId) => loadAdsInter(),
      onComplete: (adUnitId) {
        
       loadAdsInter();
      },
    );

   
  }

  showRewards() {
    UnityAds.showVideoAd(
      placementId: 'Rewarded_Android',
      onFailed: (adUnitId, error, message) =>
         loadAdsReward(),
      onStart: (adUnitId) => loadAdsReward(),
      onClick: (adUnitId) => loadAdsReward(),
      onComplete: ( reward) =>
          loadAdsReward(),
    
    );

  
  }
}
