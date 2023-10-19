import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onepref/onepref.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'firebase/firebase_functions.dart';
import 'pages/splash.dart';
import 'services/unity_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions{},
      );
  await OnePref.init();
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

  runApp(ChangeNotifierProvider(
      create: (context) => FirebaseFun(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  existAppDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('About to close app'),
              content: const Text(
                  'Your are about to exit Trivial Game, are you sure?'),
              actions: [
                TextButton(onPressed: () {}, child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('No')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Trivial Max',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      // home: const Profile(),
    );
  }
}
/*
echo "# droppoint" >> README.md
to update code
git init
git add .
git commit -m "first commit"
git branch -M main

git push -u origin main*/