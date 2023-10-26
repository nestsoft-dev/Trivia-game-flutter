import 'package:firebase_messaging/firebase_messaging.dart';



class FCMService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    final FCMToken = await _firebaseMessaging.getToken();

    initPushNotification();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    // navigatorKeyfire.currentState
    //     ?.pushNamed('/notication_screen', arguments: message);
  }

  Future<void> initPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
