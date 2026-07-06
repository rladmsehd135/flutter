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
  var subject = "jave";
  var gender = "M";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            RadioGroup(
              groupValue: subject,
                onChanged: (value){
                  setState(() {
                    subject = value!;
                  });
                },
                child: Column(
                  children: [
                    RadioListTile(value: "java", title : Text("자바")),
                    RadioListTile(value: "mySql", title : Text("mySql")),
                    RadioListTile(value: "flutter", title : Text("Flutter")),
                  ],
                )
            ),
            Divider(height: 2, color : Colors.grey),
            RadioGroup(
                groupValue: gender,
                onChanged: (value){
                  setState(() {
                    gender = value!;
                  });
                },
                child: Column(
                  children: [
                    RadioListTile(value: "M", title: Text("남자"),),
                    RadioListTile(value: "F", title: Text("여자"),),
                    RadioListTile(value: "X", title: Text("선택안함"),),
                  ],
                )
            )
          ],

        )
      ),
    );
  }
}
