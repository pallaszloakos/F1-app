import 'package:flutter/material.dart';
import 'package:f1_app/views/seasons_page.dart';
import 'package:f1_app/config.dart';


void main() async {
  await Config.loadConfig();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SeasonsPage(),
    );
  }
}


