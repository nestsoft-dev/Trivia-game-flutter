import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class MyAds{
initAds() async{
 await   UnityAds.init(
      gameId: 'PROJECT_GAME_ID',
      onComplete: () => print('Initialization Complete'),
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );
}

loadAdsInter()async{
 await UnityAds.load(
  placementId: 'PLACEMENT_ID',
  onComplete: (placementId) => print('Load Complete $placementId'),
  onFailed: (placementId, error, message) => print('Load Failed $placementId: $error $message'),
);
}

loadAdsReward() async{
  await  UnityAds.load(
  placementId: 'PLACEMENT_ID',
  onComplete: (placementId) => print('Load Complete $placementId'),
  onFailed: (placementId, error, message) => print('Load Failed $placementId: $error $message'),
);
}

showInter(){
  UnityAds.showVideoAd(
  placementId: 'PLACEMENT_ID',
  onStart: (placementId) => print('Video Ad $placementId started'),
  onClick: (placementId) => print('Video Ad $placementId click'),
  onSkipped: (placementId) => print('Video Ad $placementId skipped'),
  onComplete: (placementId) => print('Video Ad $placementId completed'),
  onFailed: (placementId, error, message) => print('Video Ad $placementId failed: $error $message'),
);
}

showRewards(){
  UnityAds.showVideoAd(
  placementId: 'PLACEMENT_ID',
  onStart: (placementId) => print('Video Ad $placementId started'),
  onClick: (placementId) => print('Video Ad $placementId click'),
  onSkipped: (placementId) => print('Video Ad $placementId skipped'),
  onComplete: (placementId) => print('Video Ad $placementId completed'),
  onFailed: (placementId, error, message) => print('Video Ad $placementId failed: $error $message'),
);
}
}