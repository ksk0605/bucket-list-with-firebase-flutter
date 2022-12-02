import 'package:bucket_list_with_firebase/controller/auth_controller.dart';
import 'package:bucket_list_with_firebase/controller/bucket_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  TextEditingController jobController = TextEditingController();

  AuthController _authController = Get.find<AuthController>();
  BucketController _bucketController = Get.find<BucketController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("버킷 리스트"),
        actions: [
          TextButton(
            child: Text(
              "로그아웃",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              // 로그아웃
              _authController.signOut();
              // 로그인 페이지로 이동
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => LoginPage()),
              // );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /// 입력창
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                /// 텍스트 입력창
                Expanded(
                  child: TextField(
                    controller: jobController,
                    decoration: InputDecoration(
                      hintText: "하고 싶은 일을 입력해주세요.",
                    ),
                  ),
                ),

                /// 추가 버튼
                ElevatedButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    // create bucket
                    if (jobController.text.isNotEmpty) {
                      _bucketController.create(
                          jobController.text, _authController.user!.value!.uid);
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1),

          /// 버킷 리스트
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
                future:
                    _bucketController.read(_authController.user!.value!.uid),
                builder: (context, snapshot) {
                  final documents = snapshot.data?.docs ?? [];
                  if (documents.isEmpty) {
                    return Center(child: Text('버킷 리스트를 작성해주세요'));
                  }
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final doc = documents[index];
                      String job = doc.get('job');
                      bool isDone = doc.get('isDone');
                      return ListTile(
                        title: Text(
                          job,
                          style: TextStyle(
                            fontSize: 24,
                            color: isDone ? Colors.grey : Colors.black,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        // 삭제 아이콘 버튼
                        trailing: IconButton(
                          icon: Icon(CupertinoIcons.delete),
                          onPressed: () {
                            // 삭제 버튼 클릭시
                            _bucketController.delete(doc.id);
                          },
                        ),
                        onTap: () {
                          // 아이템 클릭하여 isDone 업데이트
                          _bucketController.togleUpdate(doc.id, !isDone);
                        },
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
