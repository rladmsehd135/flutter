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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [Positioned(
              top: 150, left: 150,
              child: GestureDetector(
                onPanUpdate: (p){
                  print("e");
                },
                child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.lightBlue
                ),
              )
          )
          ],
        ),
      ),
    );
  }
}
