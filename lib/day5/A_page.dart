import 'package:flutter/material.dart';
import 'package:project/day5/B_Page.dart';

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
      home: APage(),
    );
  }
}

class APage extends StatefulWidget {
  const APage({super.key});

  @override
  State<APage> createState() => _APageState();
}

class _APageState extends State<APage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A 페이지"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BPage(msg: "A페이지에서 보냈습니다."),
                ),
              );
            },
            child: Text("값 보내기"),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BPage()),
              );
            },
            child: Text("그냥 이동"),
          ),
        ],
      ),
    );
  }
}