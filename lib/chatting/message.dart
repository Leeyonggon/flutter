import 'package:firstproject/chatting/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance //firebase db접근
            .collection('chat')
            .orderBy('time', descending: true) // 시간순으로 내림차순
            .snapshots(), //real-time 데이터 가져오기
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                snapshot /*최신 snapshot가져오는데 꼭 필요*/) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //snapshot data를 가져오는 중이면(waiting) 진행중이라는 indicator표시
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatdocs = snapshot
              .data!.docs; //snapshot 내부 데이터 리스트 접근 return 값은 list<> => []

          return ListView.builder(
            reverse: true,
            itemCount: chatdocs.length, // data값의 개수마다 count하기 위함 동적기능
            itemBuilder: (context, index) {
              return ChatBubbles(
                  //여기에서 uid와 message내용을 전달 받고 각각 isME와 message속성에 값을 저장
                  chatdocs[index].data()['test'],
                  chatdocs[index].data()['userid'].toString() == user!.uid,
                  chatdocs[index]
                      .data()['username']
                      .toString(), // map형식의 ['test': data]를 가져옴//isME는 bool이기 때문에 string은 bool에 종속되지않음=> .toString()사용
                  chatdocs[index].data()['userimage']);
            },
          );
        });
  }
}
