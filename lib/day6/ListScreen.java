import 'package:flutter/material.dart';
import 'package:flutter20260629/memo/Edit.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

    @override
    State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
    // 샘플 데이터
    final List<Map<String, dynamic>> list = const [
    {
        'title': 'Flutter 공부',
            'content': 'UI 구성 연습하기',
            'date': '2025-05-10',
    },
    {
        'title': '메모 앱 아이디어',
            'content': '디자인 먼저 만들고 기능은 나중에 추가',
            'date': '2025-06-11',
    },
    {
        'title': '할 일 목록',
            'content': '운동하기, 코드 정리하기, 독서하기',
            'date': '2025-06-12',
    },
            ];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
                appBar: AppBar(
                backgroundColor: Color(0xFFF8BBD0),
      ),
        body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
        Color(0xFFF8BBD0),
                Color(0xFFBBDEFB),
            ],
          ),
        ),
        child: Center(
                child: Container(
                width: 360,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
        BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
                ),
              ],
            ),
        child: Column(
                children: [
        /// 헤더
        Row(
                children: [
        Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                color: Colors.pink.shade100,
                borderRadius: BorderRadius.circular(14),
                      ),
        child: Icon(
                Icons.list_alt,
                color: Colors.pink,
                size: 26,
                      ),
                    ),
        SizedBox(width: 12),
        Text(
                '메모 목록',
                style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

        SizedBox(height: 20),

        /// 리스트
        Expanded(
                child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
            final item = list[index];

            return Container(
                    margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                        ),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            /// 제목 + 아이콘
            Row(
                    children: [
            Expanded(
                    child: Text(
                    item['title'],
                    style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
            IconButton(
                    icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.blue,
                                  ),
            onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                                builder: (context) => EditScreen(),
                                        )
                                    );
            },
                                ),
            IconButton(
                    icon: Icon(
                    Icons.delete,
                    size: 20,
                    color: Colors.red,
                                  ),
            onPressed: () {
                // 삭제 기능 연결 예정
            },
                                ),
                              ],
                            ),

            SizedBox(height: 6),

            /// 내용
            Text(
                    item['content'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                              ),
                            ),

            SizedBox(height: 10),

            /// 날짜
            Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                    item['date'],
                    style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
        },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    }
}
