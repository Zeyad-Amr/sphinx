import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/providers/UserDataProvider.dart';
import '../components/constants.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoomId;

  const ChatRoom({Key key, @required this.chatRoomId}) : super(key: key);
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageEditingController = TextEditingController();
  ScrollController _scrollController;
  void scrollToBottom() {
    try {
      final bottomOffset = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        bottomOffset,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      print('erorrrrrrrrrrrrfkffnkfn');
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    Timer(Duration(milliseconds: 200), scrollToBottom);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Consumer<User>(builder: (context, user, child) {
        return Container(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("chatRooms")
                        .document(widget.chatRoomId)
                        .collection("chats")
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      Timer(Duration(milliseconds: 500), scrollToBottom);
                      return snapshot.hasData
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              controller: _scrollController,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                var documentSnapshot =
                                    snapshot.data.documents[index].data;
                                return MessageTile(
                                  message: documentSnapshot["message"],
                                  sendByMe:
                                      user.mobile == documentSnapshot["sendBy"],
                                );
                              })
                          : Container();
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          color: Colors.grey[800],
                          child: TextField(
                            controller: messageEditingController,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: kWhiteColor),
                            decoration: InputDecoration(
                                hintText: "Message ...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        color: kPrimaryLightColor,
                        child: Center(
                          child: IconButton(
                              color: kWhiteColor,
                              icon: Icon(Icons.send, size: size.width * 0.08),
                              onPressed: () {
                                if (messageEditingController.text.isNotEmpty) {
                                  Map<String, dynamic> chatMessageMap = {
                                    "sendBy": user.mobile,
                                    "message": messageEditingController.text,
                                    'time': DateTime.now(),
                                  };

                                  Firestore.instance
                                      .collection("chatRooms")
                                      .document(widget.chatRoomId)
                                      .collection("chats")
                                      .document(DateTime.now().toString())
                                      .setData(chatMessageMap)
                                      .catchError((e) {
                                    print(e.toString());
                                  });
                                  messageEditingController.clear();
                                }
                                Timer(Duration(milliseconds: 200),
                                    scrollToBottom);
                              }),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin:
              sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: sendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23))
                  : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomRight: Radius.circular(23)),
              gradient: LinearGradient(
                colors: sendByMe
                    ? [Colors.grey[800], Colors.grey[600]]
                    : [kPrimaryLightColor, kPrimaryColor],
              )),
          child: Text(message,
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: kWhiteColor))),
    );
  }
}
