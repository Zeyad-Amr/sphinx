import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/patientApp/profile.dart';
import 'package:sphinx/components/constants.dart';
import '../accountScreens/../patientApp/appointments.dart';
import '../accountScreens/../patientApp/home.dart';
import '../accountScreens/../patientApp/messeges.dart';

class AccountPage extends StatefulWidget {
  final FirebaseUser user;

  AccountPage({
    Key key,
    @required this.user,
  })  : assert(user != null),
        super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int indexContainer;
  @override
  void initState() {
    indexContainer = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,

      //Start of AppBar................................
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          translator.translate('sphinx'),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            width: size.width * 0.2,
            child: ClipRRect(
              child: FlatButton(
                padding: EdgeInsets.all(size.height * 0.01),
                onPressed: () {
                  translator.setNewLanguage(
                    context,
                    newLanguage:
                        translator.currentLanguage == 'ar' ? 'en' : 'ar',
                    remember: true,
                    restart: true,
                  );
                },
                child: Text(
                  translator.translate('buttonTitle'),
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(29),
                    side: BorderSide(color: Colors.transparent)),
              ),
            ),
          ),
        ],
      ),
      //End of AppBar..................

      //Start of Body...............................
      body: indexContainer == 0
          ? // Home Container
          HomeWidget()
          : indexContainer == 1
              ? // Messeges Container
              MessegesWidget()
              : indexContainer == 2
                  ? // My Appointment Container
                  AppointmentWidget()
                  : indexContainer == 3
                      ? // Profile Conatiner
                      Profile1Widget(
                          firebaseAuth: _firebaseAuth,
                          user: widget.user,
                        )
                      : HomeWidget(),
      //End of Body......................
      //Start of bottomNaviagationBar ....
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey[200],
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        index: 0,
        animationCurve: Curves.easeInOutCubic,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: kPrimaryColor),
          Icon(Icons.message, size: 30, color: kPrimaryColor),
          Icon(Icons.date_range, size: 30, color: kPrimaryColor),
          Icon(Icons.portrait, size: 30, color: kPrimaryColor),
        ],
        onTap: (index) {
          print('$index');
          setState(() {
            indexContainer = index;
          });
        },
      ),
      //End of bottomNaviagationBar...............
    );
  }
}
