import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> getDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'memo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE TBL_MEMO (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            date TEXT
          )
        ''');
      },
    );
  }

  // 메모 저장
  static Future<void> insertMemo(String title, String content) async {
    final db = await getDatabase();
    await db.insert(
      'TBL_MEMO',
      {
        'title': title,
        'content': content,
        'date': DateTime.now().toIso8601String(),
      },
    );
  }

  // 메모 목록 조회 (최신순)
  static Future<List<Map<String, dynamic>>> selectMemoList() async {
    final db = await getDatabase();
    return await db.query('TBL_MEMO', orderBy: 'date DESC');
  }

  // 메모 단건 조회 (수정 화면에서 기존 내용 불러올 때 사용)
  static Future<Map<String, dynamic>?> selectMemo(int id) async {
    final db = await getDatabase();
    var result = await db.query('TBL_MEMO', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // 메모 수정
  static Future<void> updateMemo(int id, String title, String content) async {
    final db = await getDatabase();
    await db.update(
      'TBL_MEMO',
      {'title': title, 'content': content},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 메모 삭제
  static Future<void> deleteMemo(int id) async {
    final db = await getDatabase();
    await db.delete('TBL_MEMO', where: 'id = ?', whereArgs: [id]);
  }
}