import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
