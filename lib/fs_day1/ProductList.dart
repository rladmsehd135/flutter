import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final FirebaseFirestore fs = FirebaseFirestore.instance;

  // ===== 제품 삭제 =====
  Future<void> deleteProduct(String id) async {
    await fs.collection("products").doc(id).delete();
  }

  // ===== 제품 수정 =====
  Future<void> updateProduct(String id, String name, int price) async {
    await fs.collection("products").doc(id).update({
      "name": name,
      "price": price,
    });
  }

  // ===== 삭제 확인 다이얼로그 =====
  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("삭제"),
          content: Text("정말 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                deleteProduct(id);
                Navigator.of(context).pop();
              },
              child: Text("삭제"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
          ],
        );
      },
    );
  }

  // ===== 수정 다이얼로그 =====
  void showUpdateDialog(String id, String currentName, int currentPrice) {
    final editNameController = TextEditingController(text: currentName);
    final editPriceController =
    TextEditingController(text: currentPrice.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("제품 수정"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editNameController,
                decoration: InputDecoration(labelText: "제품명"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: editPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "가격"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                updateProduct(
                  id,
                  editNameController.text,
                  int.tryParse(editPriceController.text) ?? 0,
                );
                Navigator.of(context).pop();
              },
              child: Text("수정"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        // 뒤로가기 → 제품 등록 화면으로 복귀
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("제품 목록"),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
      ),
      body: StreamBuilder(
        stream: fs.collection("products").orderBy("cdate").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doc["name"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showUpdateDialog(
                                  doc.id, doc["name"], doc["price"]);
                            },
                            icon: Icon(Icons.edit, size: 20),
                          ),
                          IconButton(
                            onPressed: () {
                              showDeleteDialog(doc.id);
                            },
                            icon: Icon(Icons.delete_outline,
                                size: 20, color: Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.category_outlined,
                              size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            doc["category"],
                            style:
                            TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.payments_outlined,
                              size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            "₩ ${doc["price"]}",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(doc["content"], style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}