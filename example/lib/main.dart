import 'package:example/screen_home.dart';
import 'package:flutter/material.dart';





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwipeScreen',
      home: HomeScreen(),
    );
  }
}
