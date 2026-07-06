import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [Positioned(
              top: 50, left: 100,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.lightBlue
              )
          )
        ],
        ),
      ),
    );
  }
}
