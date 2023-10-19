import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class MyAds {
  initAds() async {
    await UnityAds.init(
      gameId: '5376898',
      testMode: true,
      onComplete: () {
        loadAdsInter();
        loadAdsReward();
        print('Ads is Loaded\n\n\n\nLoaded');
      },
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );
  }

  loadAdsInter() async {
    await UnityAds.load(
      placementId: 'Interstitial_Android',
      onComplete: (placementId) => print('Load Complete $placementId'),
      onFailed: (placementId, error, message) =>
          print('Load Failed $placementId: $error $message'),
    );
  }

  loadAdsReward() async {
    await UnityAds.load(
      placementId: 'Rewarded_Android',
      onComplete: (placementId) {
        //showRewards();
      },
      onFailed: (placementId, error, message) =>
          print('Load Failed $placementId: $error $message'),
    );
  }

  showInter() {
    UnityAds.showVideoAd(
        placementId: 'Interstitial_Android',
        onStart: (placementId) => print('Video Ad $placementId started'),
        onClick: (placementId) => print('Video Ad $placementId click'),
        onSkipped: (placementId) => print('Video Ad $placementId skipped'),
        onComplete: (placementId) {
          loadAdsInter();
        },
        onFailed: (placementId, error, message) {
          print('Ads Failed');
        });
  }

  showRewards() {
    print('Show Reward Ads Called');
    UnityAds.showVideoAd(
      placementId: 'Rewarded_Android',
      onStart: (placementId) => print('Video Ad $placementId started'),
      onClick: (placementId) => print('Video Ad $placementId click'),
      onSkipped: (placementId) => print('Video Ad $placementId skipped'),
      onComplete: (placementId) => loadAdsReward(),
      onFailed: (placementId, error, message) =>
          print('Video Ad $placementId failed: $error $message'),
    );
  }
}
