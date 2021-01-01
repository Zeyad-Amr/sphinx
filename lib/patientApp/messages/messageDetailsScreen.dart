import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/screens/VideoCall.dart';
import 'package:sphinx/screens/chatRoom.dart';
import 'package:sphinx/providers/UserDataProvider.dart';
import '../../components/constants.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MessageDetailsScreen extends StatefulWidget {
  final String doctorPhone,
      pateintPhone,
      doctorName,
      doctorNameEn,
      pateintName,
      imageUrl;
  final String descriptionEn;
  final String descriptionAr;

  const MessageDetailsScreen({
    Key key,
    @required this.doctorPhone,
    @required this.pateintPhone,
    @required this.doctorNameEn,
    @required this.imageUrl,
    @required this.pateintName,
    @required this.doctorName,
    @required this.descriptionEn,
    @required this.descriptionAr,
  }) : super(key: key);
  @override
  _MessageDetailsScreenState createState() => _MessageDetailsScreenState();
}

class _MessageDetailsScreenState extends State<MessageDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<User>(
          builder: (context, currentUser, child) => Container(
            width: double.infinity,
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/detail_message.png'),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.width * 0.1,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: BackButton(
                          color: kWhiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Text(translator.translate('calldocnow').toUpperCase(),
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 30, color: kWhiteColor)),
                  ],
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 80,
                                    child: widget.imageUrl != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              widget.imageUrl,
                                            ),
                                            radius: 40,
                                          )
                                        : CircleAvatar(
                                            backgroundColor: kPrimaryColor,
                                            radius: 40,
                                          ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      widget.doctorName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.black,
                                      ),
                                    ),
                                    translator.currentLanguage == 'en'
                                        ? Text(
                                            widget.descriptionEn,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: kPrimaryColor
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            widget.descriptionAr,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: kPrimaryColor
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.bold),
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: FlatButton.icon(
                                      icon:
                                          Icon(Icons.chat, color: Colors.white),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      color: kPrimaryColor,
                                      textColor: Colors.white,
                                      label: Text(
                                        translator.translate('message'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(color: kWhiteColor),
                                      ),
                                      onPressed: () async {
                                        // Create chat room
                                        await Firestore.instance
                                            .collection('chatRooms')
                                            .document(
                                                '${widget.doctorPhone}_${widget.pateintPhone}')
                                            .setData({
                                          'roomID':
                                              "${widget.doctorPhone}_${widget.pateintPhone}",
                                          'users': [
                                            widget.doctorPhone,
                                            widget.pateintPhone
                                          ]
                                        }).catchError(
                                                (e) => print('error isss $e'));
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ChatRoom(
                                              chatRoomId:
                                                  '${widget.doctorPhone}_${widget.pateintPhone}',
                                              sendTo: widget.doctorPhone,
                                              sendToName: widget.doctorNameEn,
                                              sendBy: widget.pateintPhone,
                                              sendByName: widget.pateintName,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: FlatButton.icon(
                                      icon: Icon(Icons.video_call,
                                          color: Colors.white),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      color: kPrimaryColor,
                                      textColor: Colors.white,
                                      label: Text(
                                        translator.translate('videoCall'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(color: kWhiteColor),
                                      ),
                                      onPressed: () {
                                        print(currentUser.email);
                                        print(currentUser.name);
                                        print(
                                            '${widget.doctorPhone}_${widget.pateintPhone}'
                                                .replaceAll(
                                                    new RegExp(r'[^\w\s]+'),
                                                    ''));
                                        Firestore.instance
                                            .collection('videoCalls')
                                            .document(
                                                '${widget.doctorPhone}_${widget.pateintPhone}' +
                                                    DateTime.now().toString())
                                            .setData({
                                          "imageUrl": 'null',
                                          "callTo": widget.doctorPhone,
                                          "callBy": widget.pateintPhone,
                                          "callToName": widget.doctorName,
                                          "callByName": widget.pateintName,
                                          "callId":
                                              '${widget.doctorPhone}_${widget.pateintPhone}'
                                                  .replaceAll(
                                                      new RegExp(r'[^\w\s]+'),
                                                      '')
                                        });
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => VideoCall(
                                              emailText: currentUser.email,
                                              subjectText:
                                                  'Online Consultation',
                                              nameText: currentUser.name,
                                              roomText:
                                                  '${widget.doctorPhone}_${widget.pateintPhone}'
                                                      .replaceAll(
                                                          new RegExp(
                                                              r'[^\w\s]+'),
                                                          ''),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: size.height * -0.18, //size.height *  -0.03
                        right: size.width * -0.25,
                        child: Image.asset('assets/images/04.png'),
                        width: size.width * 0.7,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
