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
      home : Scaffold(
        appBar: AppBar(title : Text("상단영역!")),
        body: Center(
          child: Column(
            children: [
              Image.asset("2.png", width: 200, height: 200,),
              Container(height: 50,), // box1
              SizedBox(height: 50,), //box2
              CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage("3.png"),
              )
            ]
          ),
        )
      ),
    );
  }
}
