import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'SchedulePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseFirestore fs = FirebaseFirestore.instance;
  TextEditingController idCtrl = TextEditingController();
  TextEditingController pwdCtrl = TextEditingController();

  // ===== 로그인 =====
  Future<void> login() async {
    // 1. 입력값 검증
    if (idCtrl.text.isEmpty || pwdCtrl.text.isEmpty) {
      showMsg("아이디와 비밀번호를 입력하세요");
      return;
    }

    // 2. members 컬렉션에서 아이디 + 비밀번호 일치하는 문서 검색
    final snapshot = await fs
        .collection("member")
        .where("memberId", isEqualTo: idCtrl.text)
        .where("pwd", isEqualTo: pwdCtrl.text)
        .get();

    // 3. 성공 / 실패 판단
    if (snapshot.docs.isNotEmpty) {
      // 로그인 성공 → 문서 ID를 들고 일정관리 화면으로 이동
      final memberDocId = snapshot.docs.first.id;

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SchedulePage(memberDocId: memberDocId),
          ),
        );
      }
    } else {
      // 로그인 실패
      showMsg("아이디 또는 비밀번호가 일치하지 않습니다");
      pwdCtrl.clear();
    }
  }

  // 스낵바 출력 헬퍼
  void showMsg(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  @override
  void dispose() {
    idCtrl.dispose();
    pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 20),

                // 아이디
                TextField(
                  controller: idCtrl,
                  decoration: InputDecoration(
                    labelText: '아이디',
                    hintText: '아이디를 입력하세요',
                    prefixIcon: Icon(Icons.person_outline),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                SizedBox(height: 16),

                // 비밀번호
                TextField(
                  controller: pwdCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력하세요',
                    prefixIcon: Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                SizedBox(height: 30),

                // 로그인 버튼
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      elevation: 2,
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // 하단 안내 텍스트
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '아직 회원이 아니신가요?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(width: 6),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}