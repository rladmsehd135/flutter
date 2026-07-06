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

  List<String> checkList = [];
  List<String> imgList = [
    "1.png", "2.png", "3.png"
  ];

  void listChange(String item, bool flg){
    setState(() {
      if(flg){
        checkList.add(item);
      } else {
        checkList.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body : Column(
            children: [
              Column(
                children: [
                  CheckboxListTile(
                      value: checkList.contains(imgList[0]),
                      controlAffinity : ListTileControlAffinity.leading,
                      title: Text("망곰1"),
                      onChanged: (value){
                        listChange(imgList[0], value!);
                      }
                  ),
                  CheckboxListTile(
                      value: checkList.contains(imgList[1]),
                      controlAffinity : ListTileControlAffinity.leading,
                      title: Text("망곰2"),
                      onChanged: (value){
                        listChange(imgList[1], value!);
                      }
                  ),
                  CheckboxListTile(
                      value: checkList.contains(imgList[2]),
                      controlAffinity : ListTileControlAffinity.leading,
                      title: Text("망곰3"),
                      onChanged: (value){
                        listChange(imgList[2], value!);
                      }
                  )
                ],

              ),
              Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10
                      ),
                      itemCount: checkList.length,
                      itemBuilder: (context, index){
                        return Image.asset(checkList[index]);
                      }
                  )
              )
            ],
          )
      ),
    );
  }
}
