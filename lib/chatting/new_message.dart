import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _userEnterMessage = '';
  final _controller = TextEditingController(); //text감지 controller
  void _sendMessage() async {
    //message를 보내고 firebase에 data를 전송하는 함수. db를 생성
    FocusScope.of(context)
        .unfocus(); //원하는 area를 클릭이나 해당 _sendmessage() 동작시 focus를 잃음=> 키보드가 아래로 사라짐
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      //전송버튼 누르면 db의 chat 컬렉션에 add됨 각 email마다 다른 uid로 구분됨 => chat이라는 채팅 db를 같이 사용
      //map  형태로 구성{ '' : method/func }
      'test': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': user!.uid,
      'username': userData.data()!['username'],
      'userimage': userData['pickedimage']
    });
    _controller.clear(); // textfield에 입력된 내용 clear함
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 9),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(labelText: '메세지를 입력하세요.'),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage =
                      value; //onchange method의 파라미터인 value가 변하는것을 감지하고 _userEnterMessage에 저장 => 작상할때마다 setState 실행
                });
              },
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage
                    .trim()
                    .isEmpty //textField에 입력된 text내용이 없을경우 null
                ? null
                : _sendMessage, //button을 누를 수 있게 활성화 => ()를 생략한 method는 매개변수에서 _sendMessage에 대한 포인터 역할 즉 참조 전달,
            icon: Icon(Icons.send),
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}
