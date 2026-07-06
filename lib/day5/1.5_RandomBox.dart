import 'dart:math';

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
  Random ran = Random();
  List<Widget> list = [];
  int currentIndex = 0; // 다음에 눌러야 할 박스 번호(0부터)

  void createBox() { // 박스 재배치
    const boxSize = 50.0;
    const bottomBar = 50.0;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height - bottomBar; // Stack 실제 높이

    List<Widget> tempList = [];
    for (int i = 1; i <= 10; i++) {
      tempList.add(
        Positioned(
          left: ran.nextDouble() * (w - boxSize),
          top: ran.nextDouble() * (h - boxSize),
          child: GestureDetector(
            onTap: () {
              removeBox(i - 1);
            },
            child: Container(
              width: boxSize,
              height: boxSize,
              color: Colors.green[100],
              child: Center(
                child: Text("$i"),
              ),
            ),
          ),
        ),
      );
    }
    setState(() {
      list = tempList;
      currentIndex = 0; // 새로 생성할 때 순서 초기화
    });
  }

  void removeBox(int index) {
    if (currentIndex == index) {
      setState(() {
        currentIndex++;
        list.removeAt(0);
      });
      if (list.isEmpty) {
        createBox(); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: list,
              ),
            ),
            Container(
              height: 50,
              color: Colors.grey[100],
              child: Center(
                child: ElevatedButton(
                  onPressed: createBox,
                  child: const Text("랜덤 박스 생성!"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}