import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Offset p = Offset(100, 150); // x =100, y = 150

  List<Widget> list = [

    Positioned(
        top : 20, left: 20,
        child: Container(
          height: 50 , width: 50, color: Colors.lightBlue,
        )
    ),
    Positioned(
        top : 40, left: 40,
        child: Container(
          height: 50 , width: 50, color: Colors.grey,
        )
    ),
    Positioned(
        top : 60, left: 60,
        child: Container(
          height: 50 , width: 50, color: Colors.orange,
        )
    )
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: list,
        ),
      ),
    );
  }
}
