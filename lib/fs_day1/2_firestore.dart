import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

void main() async {
  // Flutter 프레임워크와의 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase 초기화 설정
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseFirestore fs = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  Future<void> addUser() async {
    Map<String, dynamic> user = {
      "name": nameController.text,
      "age": int.parse(ageController.text),
      "cdate": Timestamp.now(),
    };

    await fs.collection("users").add(user);

    nameController.clear();
    ageController.clear();
  }

  Future<void> deleteUser(String id) async {
    await fs.collection("users").doc(id).delete();
  }

  Future<void> updateUser() async {
    final snapshot = await fs
        .collection("users")
        .where("name", isEqualTo: nameController.text)
        .get();

    for (var doc in snapshot.docs) {
      await fs.collection("users").doc(doc.id).update({
        "age": int.parse(ageController.text),
      });
    }

    nameController.clear();
    ageController.clear();
  }

  Widget getUserList() {
    return StreamBuilder(
      stream: fs.collection("users").snapshots(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(

          ));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return ListTile(
              leading: Icon(Icons.person),
              title: Text("문서ID : ${doc.id}"),
              subtitle: Text("나이 : ${doc["age"]}, 이름 : ${doc["name"]}"),
              trailing: IconButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title : Text("삭제"),
                        content: Text("정말 삭제하시겠습니까?"),
                        actions: [
                          TextButton(
                              onPressed: (){
                                deleteUser(doc.id);
                                Navigator.of(context).pop();
                              },
                              child: Text("삭제")
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: Text("취소")
                          ),
                        ],
                      );
                    },);

                  },
                  icon: Icon(Icons.delete)
              ),
            );
          }).toList(),
        );
      },
    );
  }



  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("파이어스토어!")),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "이름",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "나이",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: addUser,
                      child: Text("저장"),
                    ),
                    ElevatedButton(
                      onPressed: updateUser,
                      child: Text("수정"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(child: getUserList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}