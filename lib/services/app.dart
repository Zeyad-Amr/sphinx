import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/models/connectivity_status.dart';
import 'package:sphinx/screens/calling.dart';
import 'package:sphinx/screens/noConnection.dart';
import 'package:sphinx/screens/welcome_screens/welcome_screen1.dart';
import 'package:sphinx/services/checkUserData.dart';
import '../screens/loading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser user;
  CollectionReference userdata = Firestore.instance.collection('users');
  final fbm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fbmConfigureation();
    getDeviceToken();
    /*  fbm.subscribeToTopic('Admin'); */
    fbm.requestNotificationPermissions();

    print('///////////////////////////////////////////////////////////////');
    print('///////////////////////////////////////////////////////////////');
    print('///////////////////////////////////////////////////////////////');
  }

  void getDeviceToken() async {
    String deviceToken = await fbm.getToken();

    print('Device Token : $deviceToken');
  }

  void fbmConfigureation() async {
    fbm.configure(
      onMessage: (msg) async {
        print('onMessage: $msg');

        if (msg['data']['message'] == 'videoCall') {
          print(
              'onMessage: ${msg['data']['callId']} ,${msg['data']['callByName']}  ');

          if (msg['data']['imageUrl'] != 'null') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Calling(
                  doctorName: msg['data']['callByName'],
                  doctorPhone: msg['data']['callBy'],
                  imageUrl: msg['data']['imageUrl'],
                  pateintName: msg['data']['callToName'],
                  pateintPhone: msg['data']['callTo'],
                  callByName: msg['data']['callByName'],
                  callId: msg['data']['callId'],
                ),
              ),
            );
          } else if (msg['data']['imageUrl'] == 'null') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Calling(
                  doctorName: msg['data']['callToName'],
                  doctorPhone: msg['data']['callTo'],
                  imageUrl: 'null',
                  pateintName: msg['data']['callTByName'],
                  pateintPhone: msg['data']['callBy'],
                  callByName: msg['data']['callByName'],
                  callId: msg['data']['callId'],
                ),
              ),
            );
          }
        } else {
          DialogBackground(
            color: Colors.black.withOpacity(.2),
            blur: 0.5,
            dialog: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey)),
              title: Text(
                msg['notification']['title'],
                style: Theme.of(context).textTheme.headline5.copyWith(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
              content: Text(msg['notification']['body'],
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.headline6),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    translator.translate('ok'),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: kPrimaryLightColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ).show(context);
        }
      },
      onLaunch: (msg) async {
        print('onLanch: $msg');

        if (msg['data']['imageUrl'] != 'null') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Calling(
                doctorName: msg['data']['callByName'],
                doctorPhone: msg['data']['callBy'],
                imageUrl: msg['data']['imageUrl'],
                pateintName: msg['data']['callToName'],
                pateintPhone: msg['data']['callTo'],
                callByName: msg['data']['callByName'],
                callId: msg['data']['callId'],
              ),
            ),
          );
        } else if (msg['data']['imageUrl'] == 'null') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Calling(
                doctorName: msg['data']['callToName'],
                doctorPhone: msg['data']['callTo'],
                imageUrl: 'null',
                pateintName: msg['data']['callTByName'],
                pateintPhone: msg['data']['callBy'],
                callByName: msg['data']['callByName'],
                callId: msg['data']['callId'],
              ),
            ),
          );
        }
      },
      onResume: (msg) async {
        print('onResume: $msg');

        if (msg['data']['imageUrl'] != 'null') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Calling(
                doctorName: msg['data']['callByName'],
                doctorPhone: msg['data']['callBy'],
                imageUrl: msg['data']['imageUrl'],
                pateintName: msg['data']['callToName'],
                pateintPhone: msg['data']['callTo'],
                callByName: msg['data']['callByName'],
                callId: msg['data']['callId'],
              ),
            ),
          );
        } else if (msg['data']['imageUrl'] == 'null') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Calling(
                doctorName: msg['data']['callToName'],
                doctorPhone: msg['data']['callTo'],
                imageUrl: 'null',
                pateintName: msg['data']['callTByName'],
                pateintPhone: msg['data']['callBy'],
                callByName: msg['data']['callByName'],
                callId: msg['data']['callId'],
              ),
            ),
          );
        }
      },
    );
  }

  void getCurrentUser() async {
    FirebaseUser _user = await _firebaseAuth.currentUser();
    setState(() {
      if (_user != null) {
        user = _user;
      } else {
        print('User nullllllllllllllllllllllllllll');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    print('gg $connectionStatus');

    if (connectionStatus == null) {
      connectionStatus = ConnectivityStatus.WiFi;
    }

    if (connectionStatus == ConnectivityStatus.WiFi ||
        connectionStatus == ConnectivityStatus.Cellular) {
      return user != null
          ? CheckUserData(
              currentUserInstance: user,
            )
          : WelcomeScreen1();
    } else if (connectionStatus == ConnectivityStatus.Offline) {
      return NoConnection();
    } else {
      return LoadingScreen();
    }
  }
}
