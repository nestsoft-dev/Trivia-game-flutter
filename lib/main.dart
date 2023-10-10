import 'package:flutter/material.dart';

import 'pages/splash.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trivial Max',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
     home: const SplashScreen(),
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