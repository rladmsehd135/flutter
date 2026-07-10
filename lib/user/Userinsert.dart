import 'package:flutter/material.dart';
import 'package:project/user/UserList.dart';
import 'DB.dart';
void main(){
  runApp(const UserInsert());
}

class UserInsert extends StatelessWidget {
  const UserInsert({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserInsertScreen(),
    );
  }
}

class UserInsertScreen extends StatefulWidget {
  const UserInsertScreen({super.key});

  @override
  State<UserInsertScreen> createState() => _UserInsertScreenState();
}

class _UserInsertScreenState extends State<UserInsertScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("sqflite 실습"),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Userlist()),
                );
              },
              icon: Icon(Icons.list)
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "이름"
                ),
              ),
              TextField(
                controller: ageCtrl,
                  decoration: InputDecoration(
                      labelText: "나이"
                  ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: () async {
                    String name = nameCtrl.text;
                    int age = int.tryParse(ageCtrl.text) ?? 0;
                    await DB.insertUser(name, age);

                    nameCtrl.clear();
                    ageCtrl.clear();
                  },
                  child: Text("추가!")
              )
            ],
          ),
      ),
    );
  }
}

