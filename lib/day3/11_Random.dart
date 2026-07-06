import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Random ran = Random();
  int ranNum = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("랜덤한 숫자 : ${ranNum}"),
              SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: (){
                    ran.nextInt(10);// 0 ~ 9
                    setState(() {
                      ranNum = ran.nextInt(100) + 1;
                    });
                  },
                  child: Text("클릭")
              )
            ],
          ),
        ),
      )
    );
  }
}
