import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.isME, this.username, this.userimage,
      {super.key});

  final String message;
  final bool isME;
  final String username;
  final String userimage;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment:
            isME ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isME)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 45, 0),
              child: ChatBubble(
                clipper: ChatBubbleClipper6(type: BubbleType.sendBubble),
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 20),
                backGroundColor: Colors.blue,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: isME
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(
                        message,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!isME)
            Padding(
              padding: const EdgeInsets.fromLTRB(45, 10, 0, 0),
              child: ChatBubble(
                clipper: ChatBubbleClipper6(type: BubbleType.receiverBubble),
                backGroundColor: Color(0xffE7E7ED),
                margin: EdgeInsets.only(top: 20),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: isME
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(
                        message,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            )

          /*Container(
            decoration: BoxDecoration(
              color: isME ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: isME ? Radius.circular(0) : Radius.circular(12),
                  bottomLeft: isME ? Radius.circular(12) : Radius.circular(0)),
            ),
            width: 145,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              message,
              style: TextStyle(color: isME ? Colors.white : Colors.black),
            ),
          ),*/
        ],
      ),
      Positioned(
        bottom: 0,
        right: isME ? 5 : null,
        left: isME ? null : 5,
        child: CircleAvatar(
          backgroundImage: NetworkImage(userimage),
        ),
      )
    ]);
  }
}
