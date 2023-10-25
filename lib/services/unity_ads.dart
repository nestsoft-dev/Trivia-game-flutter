import 'package:unity_mediation/unity_mediation.dart';

class MyAds {
  initAds() async {
    await UnityMediation.initialize(
      gameId: '5376898',
      onComplete: () {
        print('Initialization Complete');
        MyAds().loadAdsInter();
        MyAds().loadAdsReward();
      },
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );
  }

  loadAdsInter() async {
    UnityMediation.loadInterstitialAd(
      adUnitId: 'Interstitial_Android',
      onComplete: (adUnitId) {},
      onFailed: (adUnitId, error, message) =>
          print('Interstitial Ad Load Failed $adUnitId: $error $message'),
    );
  }

  loadAdsReward() async {
    UnityMediation.loadRewardedAd(
      adUnitId: 'Rewarded_Android',
      onComplete: (adUnitId) {
        print('Rewarded Ad Load Complete $adUnitId');
      },
      onFailed: (adUnitId, error, message) =>
          print('Rewarded Ad Load Failed $adUnitId: $error $message'),
    );
  }

  showInter() {
     UnityMediation.showInterstitialAd(
      adUnitId: 'Interstitial_Android',
      onFailed: (adUnitId, error, message) =>
        loadAdsInter(),
      onStart: (adUnitId) => loadAdsInter(),
      onClick: (adUnitId) => loadAdsInter(),
      onClosed: (adUnitId) {
        
       loadAdsInter();
      },
    );

   
  }

  showRewards() {
    UnityMediation.showRewardedAd(
      adUnitId: 'Rewarded_Android',
      onFailed: (adUnitId, error, message) =>
         loadAdsReward(),
      onStart: (adUnitId) => loadAdsReward(),
      onClick: (adUnitId) => loadAdsReward(),
      onRewarded: (adUnitId, reward) =>
          loadAdsReward(),
      onClosed: (adUnitId) {
        print('Rewarded Ad $adUnitId closed');
        loadAdsReward();
      },
    );

  
  }
}
