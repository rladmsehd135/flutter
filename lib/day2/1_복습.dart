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
        // scaffoldBackgroundColor: Colors.white60
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "타이틀!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              letterSpacing: 2,
              decoration: TextDecoration.underline,
              decorationColor: Colors.red,
              decorationStyle: TextDecorationStyle.dashed,
            ),
          ),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.settings)),
            IconButton(onPressed: (){}, icon: Icon(Icons.home))
          ],
        ),
        drawer: Drawer(),
        body: Center(
          child: Row(
            children: [
              ElevatedButton(
                  onPressed: (){
                    print("버튼클릭");
                  },
                  child: Text("선택"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.pinkAccent,
                    shadowColor: Colors.black,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    side: BorderSide(
                      color: Colors.black,
                      width: 1
                    )
                  ),
              ),
              MyButton(text : Text("안녕?")),
              MyButton(text : Text("z?")),
              MyButton(text : Text("zzz?")),
              MyButton(text : Text("zzzz?")),

            ],
          ),

        ),
        bottomNavigationBar: BottomAppBar(),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final Text text;
  const MyButton({super.key, required Text this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: (){
            print("버튼클릭");
          },
          child: text,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              foregroundColor: Colors.pinkAccent,
              shadowColor: Colors.black,
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              side: BorderSide(
                  color: Colors.black,
                  width: 1
              )
          ),
        ),
      ],
    );
  }
}

