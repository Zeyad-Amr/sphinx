import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/providers/UserDataProvider.dart';
import '../components/constants.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoomId;
  final String sendTo;
  final String sendToName;
  final String sendBy;
  final String sendByName;

  const ChatRoom(
      {Key key,
      @required this.chatRoomId,
      @required this.sendTo,
      @required this.sendToName,
      @required this.sendBy,
      @required this.sendByName})
      : super(key: key);
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageEditingController = TextEditingController();
  ScrollController _scrollController;
  File _image;
  String _url;

  void scrollToBottom() {
    try {
      final bottomOffset = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        bottomOffset,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      print('scroll to bottom error :: $e ');
    }
  }

  void pickImage(context, String imgSource) async {
    try {
      if (imgSource == 'cam') {
        final image = await ImagePicker().getImage(source: ImageSource.camera);

        if (image == null) {
          return;
        }
        setState(() {
          if (image.path != null) {
            _image = File(image.path);
            print('path : ${image.path}');
          }
        });
      } else {
        final image = await ImagePicker().getImage(source: ImageSource.gallery);

        if (image == null) {
          return;
        }
        setState(() {
          if (image.path != null) {
            _image = File(image.path);
            print('path : ${image.path}');
          }
        });
      }
      showProgressDialog();
      /* Fluttertoast.showToast(
          msg: translator.translate('photouploading'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 5,
          backgroundColor: Colors.black.withOpacity(0.6),
          textColor: Colors.white,
          fontSize: 20.0); */
    } catch (ex) {
      print('hhhhhhhhhhhhhhhhhhhhhhg $ex');
      /* Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(translator.translate('loadingDots')),
        ),
      ); */
    }
    uploadImage(context);
  }

  void uploadImage(context) async {
    try {
      FirebaseStorage storage =
          FirebaseStorage(storageBucket: 'gs://sphinx-a2784.appspot.com/');
      StorageReference ref = storage
          .ref()
          .child(widget.chatRoomId)
          .child(p.basename('${DateTime.now()}.jpg'));
      StorageUploadTask storageUploadTask = ref.putFile(_image);

      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

      /*  Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('success'),
      )); */
      String url = await taskSnapshot.ref.getDownloadURL();
      print('url $url');
      setState(() {
        _url = url;
      });
      Map<String, dynamic> chatMessageMap = {
        "sendBy": widget.sendBy,
        "sendByName": widget.sendByName,
        "sendToName": widget.sendToName,
        "sendTo": widget.sendTo,
        "message": _url,
        "type": 'img',
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
      dismissProgressDialog();
      Navigator.of(context).pop();
      Timer(Duration(milliseconds: 200), scrollToBottom);

      /*  Fluttertoast.showToast(
          msg: translator.translate('photouploaded'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 5,
          backgroundColor: Colors.black.withOpacity(0.6),
          textColor: Colors.white,
          fontSize: 20.0); */
      return;
    } catch (ex) {
      print('hhhhhhhhhhhhhhhhhhhhhhg $ex');
      /* Fluttertoast.showToast(
          msg: translator.translate('loadingDots'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 5,
          backgroundColor: Colors.black.withOpacity(0.6),
          textColor: Colors.white,
          fontSize: 20.0); */
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
        title: Text(translator.translate('messages')),
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

                      if (snapshot.hasData) {
                        if (snapshot.data.documents.length == 0) {
                          return Container(
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: size.height * 0.3,
                                ),
                              ],
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              controller: _scrollController,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                var documentSnapshot =
                                    snapshot.data.documents[index].data;

                                return MessageTile(
                                  type: documentSnapshot["type"],
                                  message: documentSnapshot["message"],
                                  sendByMe:
                                      user.mobile == documentSnapshot["sendBy"],
                                );
                              }),
                        );
                      } else {
                        return Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.height * 0.3,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  height: size.width * 0.17,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          color: Colors.grey[800],
                          child: TextField(
                            maxLines: 10,
                            controller: messageEditingController,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: kWhiteColor),
                            decoration: InputDecoration(
                                hintText: translator.translate('typeMessage'),
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
                        color: Colors.grey[800],
                        child: Center(
                          child: IconButton(
                              color: kWhiteColor,
                              icon: Icon(Icons.camera_alt,
                                  size: size.width * 0.08),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      height: size.width * 0.2,
                                      margin: EdgeInsets.only(
                                          top: 25,
                                          bottom: 10,
                                          left: 30,
                                          right: 30),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FlatButton.icon(
                                                  icon: Icon(Icons.camera),
                                                  padding: EdgeInsets.all(15),
                                                  splashColor: Colors.grey,
                                                  onPressed: () {
                                                    pickImage(context, 'cam');
                                                    Navigator.of(context).pop();
                                                  },
                                                  label: Text(
                                                    translator
                                                        .translate('camera'),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  color: kPrimaryLightColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          color: Colors.white)),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                FlatButton.icon(
                                                  icon: Icon(Icons.image),
                                                  padding: EdgeInsets.all(15),
                                                  splashColor: Colors.grey,
                                                  onPressed: () {
                                                    pickImage(
                                                        context, 'gallery');
                                                    Navigator.of(context).pop();
                                                  },
                                                  label: Text(
                                                    translator
                                                        .translate('gallery'),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  color: kPrimaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                /*  pickImage(context, 'cam'); */

                                Timer(Duration(milliseconds: 200),
                                    scrollToBottom);
                              }),
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
                                    "sendByName": user.name,
                                    "sendToName": widget.sendToName,
                                    "sendTo": widget.sendTo,
                                    "message": messageEditingController.text,
                                    "type": 'text',
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
  final String type;

  MessageTile(
      {@required this.message, @required this.sendByMe, @required this.type});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: type == 'text'
          ? Container(
              margin: sendByMe
                  ? EdgeInsets.only(left: 30)
                  : EdgeInsets.only(right: 30),
              padding:
                  EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
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
                  color: sendByMe ? Colors.grey[800] : kPrimaryLightColor),
              child: Text(
                message,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: kWhiteColor),
              ),
            )
          : Container(
              margin: sendByMe
                  ? EdgeInsets.only(left: 30)
                  : EdgeInsets.only(right: 30),
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
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
                  color: sendByMe ? Colors.grey[800] : kPrimaryLightColor),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () {
                    print(message);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Container(
                          child: PhotoView(
                            imageProvider: NetworkImage(
                              message,
                            ),
                            loadingBuilder: (context, event) => Center(
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(
                                  value: event == null
                                      ? 0
                                      : event.cumulativeBytesLoaded /
                                          event.expectedTotalBytes,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: message,
                    filterQuality: FilterQuality.none,
                    fit: BoxFit.cover,
                    height: size.width * 0.5,
                    width: size.width * 0.5,
                    placeholder: (context, url) => Container(
                      height: size.width * 0.5,
                      width: size.width * 0.5,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
            ),
    );
  }
}

/* 
 Image(
                      filterQuality: FilterQuality.none,
                      fit: BoxFit.cover,
                      height: size.width * 0.5,
                      width: size.width * 0.5,
                      image: NetworkImage(
                        message,
                      ),
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: size.width * 0.5,
                          width: size.width * 0.5,
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Image.asset('assets/icon/icon.png');
                      },
                    ) */
