import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'package:f1_app/seasons_page.dart';

void main() {
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


