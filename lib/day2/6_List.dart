import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> list = ["김치찌개", "짜장면", "라면" , "감자탕"];
    List<Icon> iconList = [
      Icon(Icons.food_bank),
      Icon(Icons.home),
      Icon(Icons.star),
      Icon(Icons.settings)
    ];
    return MaterialApp(
      home:Scaffold(
        body: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: iconList[index],
                title: Text(list[index]),
                onTap:(){}
              );
            },
        ),
      )
    );
  }
}
