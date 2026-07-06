import 'package:flutter/material.dart';



class BPage extends StatefulWidget {
  final String? msg;
  const BPage({super.key, this.msg});

  @override
  State<BPage> createState() => _MyAppState();
}

class _MyAppState extends State<BPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("B 페이지!"),
      ),

      body: Center(
        child: Text(widget.msg ?? "B페이지! 전달 받은 값 없음!"),
      ),
    );
  }
}
