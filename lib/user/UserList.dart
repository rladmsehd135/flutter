import 'package:flutter/material.dart';
import 'package:project/user/UserEdit.dart';
import 'DB.dart';

class Userlist extends StatefulWidget {
  const Userlist({super.key});

  @override
  State<Userlist> createState() => _UserlistState();
}

class _UserlistState extends State<Userlist> {
  List<Map<String, dynamic>> list = [];

  Future<void> _selectUserList() async {
    var tempList = await DB.selectUserList();
    setState(() {
      list = tempList;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("사용자 목록"),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(list[index]["name"].toString()),
            subtitle: Text("나이: ${list[index]["age"]}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserEdit(userId: list[index]["userId"]),
                        ),
                      );
                      if (result == true) {
                        _selectUserList(); // 수정하고 돌아오면 목록 새로고침
                      }
                    },
                    icon: Icon(Icons.edit)
                ),
                IconButton(
                    onPressed: (){
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("삭제"),
                            content: Text("${list[index]["name"]} 정말 삭제함?"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await DB.deleteUser(list[index]["userId"]);
                                  Navigator.of(context).pop();
                                  _selectUserList();
                                },
                                child: Text("삭제"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("취소"),
                              )
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.delete)
                )
              ],
            ),
          );
        },
      ),
    );
  }
}