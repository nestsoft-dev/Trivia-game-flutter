import 'package:flutter/material.dart';

import 'pages/splash.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
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
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Yes')),
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WillPopScope(
          onWillPop: existAppDialog(context), child: const SplashScreen()),
      //home: const HomePage(),
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