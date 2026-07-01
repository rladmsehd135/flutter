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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title : Text("상단영역!"),
          backgroundColor: Colors.blue[200],
        ),
        drawer: Drawer(),
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "가운데",
                style:TextStyle(
                    color : Colors.black,
                    fontWeight : FontWeight.bold,
                    fontSize: 50
                )
              ),
              SizedBox(height: 10,),
              Icon(Icons.star, size : 200, color: Colors.yellow,),
              SizedBox(height: 10,),
                Container(
                  height: 100, width: 100,
                  color: Colors.black,
                  child: Center(child: Text("네모박스", style: TextStyle(color: Colors.white),)),
                )




            ],

          ),
        )
      )
    );
  }
}
