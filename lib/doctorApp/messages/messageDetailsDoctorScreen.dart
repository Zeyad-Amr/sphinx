import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/providers/UserDataProvider.dart';
import 'package:sphinx/screens/chatRoom.dart';
import 'package:sphinx/screens/VideoCall.dart';
import '../../components/constants.dart';

class MessageDetailsDoctorScreen extends StatefulWidget {
  final String doctorPhone,
      pateintPhone,
      doctorName,
      age,
      gender,
      country,
      patientName,
      documentId;

  const MessageDetailsDoctorScreen(
      {Key key,
      @required this.doctorPhone,
      @required this.pateintPhone,
      @required this.doctorName,
      @required this.age,
      @required this.gender,
      @required this.country,
      @required this.patientName,
      @required this.documentId})
      : super(key: key);
  @override
  _MessageDetailsDoctorScreenState createState() =>
      _MessageDetailsDoctorScreenState();
}

class _MessageDetailsDoctorScreenState
    extends State<MessageDetailsDoctorScreen> {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd K:mm a');

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
                  height: 30,
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
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Text('Call your\npatient Now'.toUpperCase(),
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 30, color: kWhiteColor)),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: FlatButton.icon(
                                      icon: Icon(Icons.exit_to_app,
                                          color: Colors.white),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      color: Colors.red[800],
                                      textColor: Colors.white,
                                      label: Text(
                                        'End Consultation',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(color: kWhiteColor),
                                      ),
                                      onPressed: () async {
                                        Firestore.instance
                                            .collection('appointments')
                                            .document(widget.documentId)
                                            .updateData({
                                          'state': 1,
                                          'endDate':
                                              dateFormat.format(DateTime.now())
                                        });

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(width: size.width * 0.05),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.patientName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        translator.translate('mob') +
                                            ': ' +
                                            widget.pateintPhone
                                                .toString()
                                                .split('')
                                                .getRange(2, 13)
                                                .join()
                                                .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                color: kPrimaryColor
                                                    .withOpacity(1)),
                                      ),
                                      translator.currentLanguage == 'en'
                                          ? Text(
                                              'Country: ' + widget.country,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      color: Colors.grey[600]),
                                            )
                                          : Text(
                                              'البلد: ' + widget.country,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      color: Colors.grey[600]),
                                            ),
                                      Text(
                                        translator.translate('age') +
                                            ': ' +
                                            widget.age,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(color: Colors.grey[600]),
                                      ),
                                      widget.gender == 'Male' ||
                                              widget.gender == 'ذكر'
                                          ? Text(
                                              translator.translate('gender') +
                                                  ': ' +
                                                  translator.translate('male'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      color: Colors.grey[600]),
                                            )
                                          : Text(
                                              translator.translate('gender') +
                                                  ': ' +
                                                  translator
                                                      .translate('female'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      color: Colors.grey[600]),
                                            )
                                    ],
                                  ),
                                ],
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
                                        'Message',
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
                                              sendTo: widget.pateintPhone,
                                              sendToName: widget.patientName,
                                              sendBy: widget.doctorPhone,
                                              sendByName: widget.doctorName,
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
                                        'Video Call',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(color: kWhiteColor),
                                      ),
                                      onPressed: () {
                                        print(currentUser.email);
                                        print(currentUser.name);
                                        print(
                                            '${widget.doctorPhone.toString().split('').getRange(2, 13).join().toString()}_${widget.pateintPhone.toString().split('').getRange(2, 13).join().toString()}');
                                        Firestore.instance
                                            .collection('videoCalls')
                                            .document(
                                                '${widget.doctorPhone}_${widget.pateintPhone}' +
                                                    DateTime.now().toString())
                                            .setData({
                                          "callBy": widget.doctorPhone,
                                          "callTo": widget.pateintPhone,
                                          "callByName": widget.doctorName,
                                          "callToName": widget.patientName,
                                        });
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => VideoCall(
                                              emailText: currentUser.email,
                                              subjectText:
                                                  'Online Consultation',
                                              nameText: currentUser.name,
                                              roomText:
                                                  '${widget.doctorPhone.toString().split('').getRange(2, 13).join().toString()}_${widget.pateintPhone.toString().split('').getRange(2, 13).join().toString()}',
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
                        bottom: size.height * -0.12, //size.height *  -0.03
                        right: size.width * -0.22,
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
