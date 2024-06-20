import 'package:flutter/material.dart';

import 'buttons.dart';
import 'genderClassification.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'mainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.deepOrangeAccent,
          title: Text(
            'Image Classification',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(top: 15),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListContent(
                text: 'Trash Classification',
                imagePath: 'assets/splash_image.png',
                onClick: () {
                  Navigator.pushNamed(context, GenderClassification.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
