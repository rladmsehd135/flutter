import 'package:flutter/material.dart';
import 'DB.dart';

class UserEdit extends StatefulWidget {
  final int userId;
  const UserEdit({super.key, required this.userId});

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  Future<void> _selectUser() async {
    var user = await DB.selectUser(widget.userId);
    if (user != null) {
      setState(() {
        _nameController.text = user["name"].toString();
        _ageController.text = user["age"].toString();
      });
    }
  }

  Future<void> _updateUser() async {
    String name = _nameController.text.trim();
    int? age = int.tryParse(_ageController.text.trim());

    if (name.isEmpty || age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이름과 나이를 올바르게 입력하세요")),
      );
      return;
    }

    await DB.updateUser(name, age, widget.userId);
    if (mounted) {
      Navigator.of(context).pop(true); // 수정 완료 신호 전달
    }
  }

  @override
  void initState() {
    super.initState();
    _selectUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("사용자 수정"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "이름",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "나이",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateUser,
                child: const Text("저장"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}