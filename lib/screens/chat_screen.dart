import 'package:firstproject/chatting/message.dart';
import 'package:firstproject/chatting/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication =
      FirebaseAuth.instance; //firebase의 auth값을 알려줌,db상에 있는 instance 전달
  User? loggedUser; // loggeduser 변수 초기화값에 null이 있을 수 있음=> ? // null이 절대 없음 => !

  @override
  void initState() {
    //e동일 위젯트리내에 부모위젯에 의존하는 속성 초기화(getCurrentUser). http통신 사용시 사용
    // TODO: implement initState
    super.initState(); // 필수 코드
    getCurrentUser();
  }

  void getCurrentUser() {
    //로그인된 email을  .currentUser로 알아와서 현재 로그인된 정보의 이메일을 나타내줌
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatting'),
        actions: [
          IconButton(
              //로그아웃 기능
              onPressed: () {
                _authentication.signOut();
                //Navigator.pop(context);
              },
              icon: Icon(
                Icons.exit_to_app_rounded,
                color: Colors.green,
              ))
        ],
      ),
      body: Container(
        child: Column(
          // 상하배치
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
