
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import '../firebase_options.dart';

void main() async {
  // Flutter 프레임워크와의 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase 초기화 설정
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore fs = FirebaseFirestore.instance;
    // fs 객체를 이용해서 db에 접근
    // # crud 예시
    // 0. users 컬랙션에 접근 : fs.collection("users");
    // 1. 삽입 : fs.collection("users").add(데이터(맵));
    // 2. 목록 : fs.collection("users").get();
    // 3. 수정 : fs.collection("users").update(데이터(맵));
    // 4. 삭제 : fs.collection("users").delete(데이터(맵)));


    Future<void> getUserList() async{
      final snapshot =
      await fs.collection("users")
          .where("age", isGreaterThan: 20)
          .orderBy("age", descending: true) //age 필드 기준으로 오름차순
          .get();
    }

    Future<void> addUser() async{
      Map<String, dynamic> user = {
        "name" : "김철수",
        "age" : 20 ,
        "cdate" : Timestamp.now()
      };

      fs.collection("users").add(user);
    }

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: addUser,
                  child: Text("추가!")
              )
            ],
          ),
        ),
      ),
    );
  }
}
