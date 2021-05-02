import 'package:client_web/design/colorSet.dart';
import 'package:client_web/page/section/mainPageSection/scoreboard.dart';
import 'package:client_web/page/section/mainPageSection/showcase.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Size displaySize;

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorSet.mainColor,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ShowCase(),
            ScoreBoard(),
          ],
        ),
      ),
    );
  }
}
