import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        children: [
          Container(
            width: 150, height: 150,
            color: Colors.lightBlueAccent,
            child: Center(child: Text("box1")),
          ),
          MyBox(150, 150,Colors.yellow, "box!!"),
          MyBox(100, 100,Colors.green, "bzzzz!!")
        ],

      )
    );
  }
}

class MyBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final String txt;
  const MyBox(double this.width, double this.height, Color this.color, String this.txt, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, height: height,
      color: color,
      child: Center(child: Text(txt)),
    );
  }
}

