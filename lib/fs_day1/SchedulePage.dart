import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  final String memberDocId; // 로그인한 회원의 문서 ID

  const SchedulePage({super.key, required this.memberDocId});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  FirebaseFirestore fs = FirebaseFirestore.instance;
  TextEditingController scheduleCtrl = TextEditingController();

  // ===== 일정 추가 =====
  Future<void> addSchedule() async {
    if (scheduleCtrl.text.isEmpty) return;

    // member/{문서ID}/schedule 하위 컬렉션에 추가
    await fs
        .collection("member")
        .doc(widget.memberDocId)
        .collection("schedule")
        .add({
      "content": scheduleCtrl.text,
      "cdate": Timestamp.now(),
    });

    scheduleCtrl.clear();
  }

  // ===== 일정 삭제 =====
  Future<void> deleteSchedule(String scheduleId) async {
    await fs
        .collection("member")
        .doc(widget.memberDocId)
        .collection("schedule")
        .doc(scheduleId)
        .delete();
  }

  @override
  void dispose() {
    scheduleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('개인일정관리')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: scheduleCtrl,
                    decoration: InputDecoration(
                      labelText: '새 일정',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addSchedule,
                  child: Text('추가'),
                ),
              ],
            ),
          ),
          Expanded(
            // 해당 회원의 하위 컬렉션(schedule)만 실시간 스트림으로 가져옴
            child: StreamBuilder(
              stream: fs
                  .collection("member")
                  .doc(widget.memberDocId)
                  .collection("schedule")
                  .orderBy("cdate", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // 일정이 하나도 없을 때
                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("등록된 일정이 없습니다"));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return ListTile(
                      leading: Icon(Icons.event_note),
                      title: Text(doc["content"]),
                      trailing: IconButton(
                        onPressed: () {
                          deleteSchedule(doc.id);
                        },
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}