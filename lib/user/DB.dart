import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  // 데이터베이스 경로와 이름 정의
  static Future<Database> getDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // 데이터베이스가 없다면 생성하고 테이블을 생성하는 작업
    return await openDatabase(path, version: 2, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE TBL_USER(
          userId INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT, 
          age INTEGER
        )
      ''');

    },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
        CREATE TABLE TBL_USER(
          userId INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT, 
          age INTEGER
        )
      ''');
        }
      },
    );

  }


  static Future<void> insertUser(String name , int age) async{
    final db = await getDatabase();
    await db.insert("TBL_USER", {'name' : name, 'age' : age});
  }
  static Future<List<Map<String, dynamic>>> selectUserList() async{
    final db = await getDatabase();
    return await db.query("TBL_USER");
  }
}

