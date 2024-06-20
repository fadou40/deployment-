import 'package:classification/splashScreen.dart';
import 'package:flutter/material.dart';

import 'genderClassification.dart';
import 'mainScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Classification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SplashPage(),
      routes: {
        SplashPage.id: (context) => SplashPage(),
        MainScreen.id: (context) => MainScreen(),
        GenderClassification.id: (context) => GenderClassification(),
      },
    );
  }
}
