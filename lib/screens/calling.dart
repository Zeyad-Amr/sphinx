import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/providers/UserDataProvider.dart';
import 'package:sphinx/screens/VideoCall.dart';
import 'package:sphinx/screens/chatRoom.dart';

class Calling extends StatefulWidget {
  final String callId, callByName;
  final String doctorPhone, pateintPhone, doctorName, pateintName, imageUrl;

  const Calling({
    Key key,
    @required this.callId,
    @required this.callByName,
    @required this.doctorPhone,
    @required this.pateintPhone,
    @required this.doctorName,
    @required this.pateintName,
    @required this.imageUrl,
  }) : super(key: key);
  @override
  _CallingState createState() => _CallingState();
}

class _CallingState extends State<Calling> {
  @override
  void initState() {
    super.initState();

    FlutterRingtonePlayer.playRingtone();
  }

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
                    Text(translator.translate('call').toUpperCase(),
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
                                    child: widget.imageUrl != 'null'
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              widget.imageUrl,
                                            ),
                                            radius: 40,
                                          )
                                        : CircleAvatar(
                                            backgroundImage: AssetImage(
                                              'assets/images/user.png',
                                            ),
                                            radius: 40,
                                          ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.callByName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.black,
                                    ),
                                  ),
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
                                              sendToName: widget.doctorName,
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
                                        print('Idddddddddddd ${widget.callId}');
                                         FlutterRingtonePlayer.stop();
                                          Navigator.of(context).pop();
                                        /*    Firestore.instance
                      .collection('videoCalls')
                      .document('${widget.doctorPhone}_${widget.pateintPhone}' +
                          DateTime.now().toString())
                      .setData({
                    "callBy": widget.doctorPhone,
                    "callTo": widget.pateintPhone,
                    "callByName": widget.doctorName,
                    "callToName": widget.patientName,
                    "callId":
                        '${widget.doctorPhone.toString().split('').getRange(2, 13).join().toString()}_${widget.pateintPhone.toString().split('').getRange(2, 13).join().toString()}'
                  }); */
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => VideoCall(
                                              emailText: currentUser.email,
                                              subjectText:
                                                  'Online Consultation',
                                              nameText: currentUser.name,
                                              roomText: '${widget.callId}',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      child: FlatButton.icon(
                                        icon: Icon(Icons.cancel,
                                            color: Colors.white),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        color: Colors.red[800],
                                        textColor: Colors.white,
                                        label: Text(
                                          translator.translate('reject'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(color: kWhiteColor),
                                        ),
                                        onPressed: () {
                                          FlutterRingtonePlayer.stop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: size.height * -0.2, //size.height *  -0.03
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

/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<User>(
        builder: (context, currentUser, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.callByName + translator.translate('calling_you')),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.06,
              child: FlatButton.icon(
                icon: Icon(Icons.video_call, color: Colors.white),
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
                  print('Idddddddddddd ${widget.callId}');
                  /*    Firestore.instance
                      .collection('videoCalls')
                      .document('${widget.doctorPhone}_${widget.pateintPhone}' +
                          DateTime.now().toString())
                      .setData({
                    "callBy": widget.doctorPhone,
                    "callTo": widget.pateintPhone,
                    "callByName": widget.doctorName,
                    "callToName": widget.patientName,
                    "callId":
                        '${widget.doctorPhone.toString().split('').getRange(2, 13).join().toString()}_${widget.pateintPhone.toString().split('').getRange(2, 13).join().toString()}'
                  }); */
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoCall(
                        emailText: currentUser.email,
                        subjectText: 'Online Consultation',
                        nameText: currentUser.name,
                        roomText: '${widget.callId}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */
