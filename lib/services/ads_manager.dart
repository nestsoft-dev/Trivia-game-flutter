import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdManager {
  static String get gameId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return '5449339';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'your_ios_game_id';
    }
    return '';
  }

  static String get interstitialAdUnitId {
    return 'Interstitial_Android';
  }

  static String get rewardedAdUnitId {
    return 'Rewarded_Android';
  }

  static String get bannerAdUnitId {
    return 'Banner_Android';
  }
}
