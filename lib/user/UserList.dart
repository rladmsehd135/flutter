import 'package:flutter/material.dart';
import 'DB.dart';
    
    class Userlist extends StatefulWidget {
      const Userlist({super.key});
    
      @override
      State<Userlist> createState() => _UserlistState();
    }
    
    class _UserlistState extends State<Userlist> {
      List<Map<String, dynamic>> list = [];

      Future<void> _selectUserList() async{
        var tempList = await DB.selectUserList();
        setState(() {
          list = tempList;
        });
      }

      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectUserList();

  }

      @override
      Widget build(BuildContext context) {
        print(list[1]["name"]);
        return Scaffold(
          appBar: AppBar(
            title: Text("사용자 목록"),

          ),
          body: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.home),
                  title: Text("집 고고"),
                  subtitle: Text("고고~~~~"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit),
                      Icon(Icons.delete)
                    ],
                  ),
                );
              },
          ),
        );
      }
    }
    