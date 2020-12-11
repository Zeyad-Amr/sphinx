import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/models/connectivity_status.dart';
import 'package:sphinx/screens/noConnection.dart';
import 'package:sphinx/screens/welcome_screens/welcome_screen1.dart';
import 'package:sphinx/services/checkUserData.dart';
import '../screens/loading.dart';

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
    fbm.subscribeToTopic('Admin');
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
      onMessage: (msg) {
        print('onMessage: $msg');

        return;
      },
      onLaunch: (msg) {
        print('onLanch: $msg');

        return;
      },
      onResume: (msg) {
        print('onResume: $msg');

        return;
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
