import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY = 'Review';

class MyInAppReview {
  late SharedPreferences _pref;
  final InAppReview _inAppReview = InAppReview.instance;

  Future<bool> isSecondTimeOpen() async {
    _pref = await SharedPreferences.getInstance();
    try {
      dynamic isSecondTime = _pref.getBool(KEY) as bool;
      if (isSecondTime != null && !isSecondTime) {
        _pref.setBool(KEY, false);
        return false;
      } else if (isSecondTime != null && isSecondTime) {
        _pref.setBool(KEY, false);
        return false;
      } else {
        _pref.setBool(KEY, false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> showRating() async {
    try {
      final available = await _inAppReview.isAvailable();
      if (available) {
        _inAppReview.requestReview();
      } else {
        _inAppReview.openStoreListing(
            appStoreId: 'com.netsoftdevelopers.trival_game');
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
