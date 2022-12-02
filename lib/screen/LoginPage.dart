import 'package:bucket_list_with_firebase/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그인")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 현재 유저 로그인 상태
            Center(
              child: Text(
                _authController.user?.value == null
                    ? "로그인해 주세요 🙂"
                    : "${_authController.user?.value?.email}님 안녕하세요 👋",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 32),

            /// 이메일
            TextField(
              controller: _emailController,
              decoration: InputDecoration(hintText: "이메일"),
            ),

            /// 비밀번호
            TextField(
              controller: _passwordController,
              obscureText: false, // 비밀번호 안보이게
              decoration: InputDecoration(hintText: "비밀번호"),
            ),
            SizedBox(height: 32),

            /// 로그인 버튼
            ElevatedButton(
              child: Text("로그인", style: TextStyle(fontSize: 21)),
              onPressed: () {
                // 로그인
                _authController.signIn(
                  email: _emailController.text,
                  password: _passwordController.text,
                  onSuccess: () {
                    // 로그인 성공
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("로그인 성공"),
                    ));

                    // // HomePage로 이동
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => HomePage()),
                    // );
                  },
                  onError: (err) {
                    // 에러 발생
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(err),
                    ));
                  },
                );
              },
            ),

            /// 회원가입 버튼
            ElevatedButton(
              child: Text("회원가입", style: TextStyle(fontSize: 21)),
              onPressed: () {
                // 회원가입
                _authController.signUp(
                  email: _emailController.text,
                  password: _passwordController.text,
                  onSuccess: () {
                    // 회원가입 성공
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("회원가입 성공"),
                    ));
                  },
                  onError: (err) {
                    // 에러 발생
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(err),
                    ));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
