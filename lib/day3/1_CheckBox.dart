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
  bool? javaChecked = false;
  bool? mySqlChecked = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Checkbox(
                    value: javaChecked,
                    onChanged: (value){
                      setState(() {
                        javaChecked = value!;
                      });

                      // print(value);
                    }
                ),
                Text("자바")
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: mySqlChecked,
                    onChanged: (value){
                      setState(() {
                        mySqlChecked = value!;
                      });
                    }
                ),
                Text("MySql")
              ],
            )
          ],
        )
      ),
    );
  }
}
