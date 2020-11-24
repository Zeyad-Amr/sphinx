import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/providers/UserDataProvider.dart';
import 'package:sphinx/data_screens/dataEditing.dart';
import 'package:sphinx/services/app.dart';

class Profile1WidgetAdmin extends StatefulWidget {
  final FirebaseUser user;
  const Profile1WidgetAdmin({
    Key key,
    @required FirebaseAuth firebaseAuth,
    @required this.user,
  }) : super(key: key);

  @override
  _Profile1WidgetAdminState createState() => _Profile1WidgetAdminState();
}

class _Profile1WidgetAdminState extends State<Profile1WidgetAdmin>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  String ageValue;
  String genderValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Container(
      height: size.height,
      width: size.width,
      color: Colors.grey[200],
      child: Consumer<User>(
        builder: (context, currentUser, child) {
          return ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, bottom: 20),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        translator.translate('profile'),
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          // Profile data .............................................
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 1.0,
                                    ),
                                  ],
                                ),
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      child: Container(
                                        color: kPrimaryColor,
                                        height: size.height * 0.1,
                                        width: size.width * 0.08,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0,
                                          bottom: 15.0,
                                          left: 20,
                                          right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /*  Text(
                                            translator.translate('name'),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ), */
                                          Text(
                                            currentUser.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 23.0,
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                          Text(
                                            currentUser.mobile,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          /*   // Name ................................................................
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Colors.black,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 8.0),
                                    child: new Row(
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              translator.translate('name'),
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, bottom: 8.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            currentUser.name,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Mobile Number ...............................................
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Colors.black,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 8.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              translator.translate('mobile'),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, bottom: 8.0),
                                  child: new Row(
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            widget.user.phoneNumber,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
 */
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          // Edit Data .................................................................
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print('eeeeeeeeeeeeeeeeeeeer');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DataEditing(
                                        user: widget.user,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  width: size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0,
                                            bottom: 15.0,
                                            left: 20,
                                            right: 20),
                                        child: Align(
                                          alignment:
                                              translator.currentLanguage == 'en'
                                                  ? Alignment.centerLeft
                                                  : Alignment.centerRight,
                                          child: Text(
                                              translator
                                                  .translate('editprofile'),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Icon(
                                          Icons.edit,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          // Sign Out .................................................................
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  currentUser.signOut();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => App(),
                                      ),
                                      (Route<dynamic> route) => false);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  width: size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0,
                                            bottom: 15.0,
                                            left: 20,
                                            right: 20),
                                        child: Align(
                                          alignment:
                                              translator.currentLanguage == 'en'
                                                  ? Alignment.centerLeft
                                                  : Alignment.centerRight,
                                          child: Text(
                                              translator.translate('signout'),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Icon(
                                          Icons.exit_to_app,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /* Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DataEditing(
                user: widget.user,
              ),
            ),
          );
        });
      },
    );
  } */
}
