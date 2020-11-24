import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/doctorApp/profileDoctor.dart';
import 'appointmentsDoctor.dart';
import 'homeDoctor.dart';
import 'messegesDoctor.dart';

class AccountPageDoctor extends StatefulWidget {
  final FirebaseUser user;

  AccountPageDoctor({
    Key key,
    @required this.user,
  })  : assert(user != null),
        super(key: key);

  @override
  _AccountPageDoctorState createState() => _AccountPageDoctorState();
}

class _AccountPageDoctorState extends State<AccountPageDoctor> {
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
      resizeToAvoidBottomInset: true,

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
          HomeWidgetDoctor()
          : indexContainer == 1
              ? // Messeges Container
              MessegesWidgetDoctor()
              : indexContainer == 2
                  ? // My Appointment Container
                  AppointmentWidgetDoctor()
                  : indexContainer == 3
                      ? // Profile Conatiner
                      Profile1WidgetDoctor(
                          firebaseAuth: _firebaseAuth,
                          user: widget.user,
                        )
                      : HomeWidgetDoctor(),
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
          Icon(Icons.calendar_today, size: 30, color: kPrimaryColor),
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
