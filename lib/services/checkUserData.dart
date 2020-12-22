import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/adminApp/accountPageAdmin.dart';
import 'package:sphinx/doctorApp/AccountPageDoctor.dart';
import 'package:sphinx/patientApp/accountPage.dart';
import 'package:sphinx/providers/UserDataProvider.dart';
import 'package:sphinx/data_screens/dataEntering.dart';
import 'package:sphinx/screens/loading.dart';

class CheckUserData extends StatefulWidget {
  final FirebaseUser currentUserInstance;
  CheckUserData({
    Key key,
    this.currentUserInstance,
  }) : super(key: key);

  @override
  _CheckUserDataState createState() => _CheckUserDataState();
}

class _CheckUserDataState extends State<CheckUserData> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  String type;
  String userType;

  CollectionReference userdata = Firestore.instance.collection('users');
  final fbm = FirebaseMessaging();

  @override
  void initState() {
    checkCurrentUser();
    super.initState();
  }

  Future<void> checkCurrentUser() async {
    FirebaseUser _user = await _firebaseAuth.currentUser();

    if (_user != null) {
      setState(() {
        user = _user;
      });

      Firestore.instance
          .collection('users')
          .document(_user.phoneNumber)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('Document exists on the database');
          setState(() {
            type = 'old';
            userType = documentSnapshot.data['info'];
            print(userType);
          });
        } else if (!documentSnapshot.exists) {
          print('Document doesnt exist on the database');
          setState(() {
            type = 'new';
          });
        } else {
          print('Erooooooooooooooooooooor');
        }
      }).catchError((error) => print('Something wrong ........ $error'));
    } else {
      print('Nulllllllll in checking');
    }
  }

  void getDeviceToken() async {
    FirebaseUser _user = await _firebaseAuth.currentUser();
    String deviceToken = await fbm.getToken();
    userdata.document(_user.phoneNumber).updateData({'token': deviceToken});
    print('Device Token : $deviceToken');
  }

  @override
  Widget build(BuildContext context) {
    User model;
    model = Provider.of<User>(context, listen: false);
    print('ya userrrrrrrrrrrrrrrrrr is $user');

    if (type == 'old') {
      model.getUserData(user);

      print('i am an old user get my data');
      print('current user name is ${model.name}');
    }
    return FutureBuilder(
      future: Provider.of<User>(context, listen: false).getUserData(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          print('Error ${snapshot.error}');
          return LoadingScreen();
        } else {
          if (type == 'old') {
            getDeviceToken();
            if (userType == 'admin') {
              return AccountPageAdmin(
                user: user,
              );
            } else if (userType == 'patient') {
              return AccountPage(
                user: user,
              );
            } else if (userType == 'doctor') {
              return AccountPageDoctor(
                user: user,
              );
            } else {
              return LoadingScreen();
            }
          } else if (type == 'new') {
            return DataEntering(
              user: user,
            );
          } else {
            return LoadingScreen();
          }
        }
      },
    );
  }
}

/* 
if (userType == 'admin') {
            return AccountPageAdmin(
              user: user,
            );
          } else if (userType == 'patient') {
            return type == 'new'
                ? DataEntering(
                    user: user,
                  )
                : AccountPage(
                    user: user,
                  );
          } else {
            return LoadingScreen();
          } */
