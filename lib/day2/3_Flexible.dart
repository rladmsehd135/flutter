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
      home: Scaffold(
        body: Row(
          children: [
            Flexible(child: Container(color: Colors.red,),flex : 1),
            Flexible(child: Container(color: Colors.blue),flex : 2),
            Flexible(child: Container(color: Colors.green), flex : 1)
          ],
        )
      ),
    );
  }
}
