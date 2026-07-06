import 'package:flutter/material.dart';

void main(){
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
      home: MyHome()
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("배규ㅗ파"),
                      duration: Duration(seconds: 3),
                      action: SnackBarAction(
                        label: "이동",
                        onPressed: (){

                        },
                      ),
                  )

              );
            },
            child: Text("클릭!")
        ),
      ),
    );
  }
}

