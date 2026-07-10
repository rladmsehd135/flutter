import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RandomBoxPage(),
    );
  }
}

class RandomBoxPage extends StatefulWidget {
  const RandomBoxPage({super.key});

  @override
  State<RandomBoxPage> createState() => _RandomBoxPageState();
}

class _RandomBoxPageState extends State<RandomBoxPage> {
  final Random ran = Random();
  List<Offset>? positions;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;


    positions ??= List.generate(
      10,
          (_) => Offset(
        ran.nextDouble() * (w - 50),
        ran.nextDouble() * (h - 50),
      ),
    );

    return Scaffold(
      body: Stack(
        children: List.generate(10, (i) {
          return Positioned(
            left: positions![i].dx,
            top: positions![i].dy,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.green,
              alignment: Alignment.center,
              child: Text(
                '${i + 1}', // 1부터 10까지
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          );
        }),
      ),
    );
  }
}