import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ndialog/ndialog.dart';
import 'package:sphinx/components/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AddNotification extends StatefulWidget {
  @override
  _AddNotificationState createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  DateFormat dateorderFormat = DateFormat('yyyyMMddkkmmss');
  String titleEn, titleAr, messageEn, messageAr, linkUrl;

  Future<void> addNotifications(
      {String titleEn,
      String titleAr,
      String messageEn,
      String messageAr,
      String link}) {
    CollectionReference notif = Firestore.instance.collection('Notifications');
    return notif
        .document(dateorderFormat.format(DateTime.now()))
        .setData({
          'titleEn': titleEn,
          'titleAr': titleAr,
          'messageEn': messageEn,
          'messageAr': messageAr,
          "link": link,
          'date': dateorderFormat.format(
            DateTime.now(),
          )
        })
        .then((value) => print(" notif"))
        .catchError((error) => print("Failed to add : $error"));
  }

  /* Future<void> updateServices(
      {String titleEn,
      String titleAr,
      String messageEn,
      String messageAr,
      String date}) {
    CollectionReference service =
        Firestore.instance.collection('Notifications');

    return service
        .document(date)
        .updateData({
          'titleEn': titleEn,
          'titleAr': titleAr,
          'messageEn': messageEn,
          'messageAr': messageAr,
        })
        .then((value) => print('update'))
        .catchError((error) => print("Failed to add user: $error"));
  } */
/* 
  deleteData(String name) {
    DocumentReference documentReference = Firestore.instance
        .collection("services_collections/collections/${widget.collection}")
        .document(name);

    documentReference.delete().whenComplete(() {
      return Fluttertoast.showToast(
          msg: '$name ' + translator.translate('deleteSuccess'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 5,
          backgroundColor: Colors.red[600].withOpacity(0.9),
          textColor: Colors.white,
          fontSize: 20.0);
    });
  } */

  _launchURL(url) async {
    if (url == "null") {
    } else if (await canLaunch(url) == true) {
      await launch(url);
    } else if (await canLaunch(url) == false) {
      return Fluttertoast.showToast(
          msg: translator.translate('invalidLink'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 5,
          backgroundColor: Colors.red[600].withOpacity(0.9),
          textColor: Colors.white,
          fontSize: 20.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translator.translate('notifications')),
      ),
      body: Container(
          height: size.height,
          width: size.width,
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: size.width,

                  // Add Notif Button ..................................................................
                  child: FlatButton(
                    child: Text(
                      translator.translate('sendNotification'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    padding: EdgeInsets.all(size.height * 0.02),
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey)),
                    splashColor: Colors.grey,
                    onPressed: () {
                      DialogBackground(
                        color: Colors.black.withOpacity(.2),
                        blur: 0.5,
                        dialog: Builder(
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: Colors.grey)),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  translator.translate('newNotif'),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp('[/]')),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: translator.translate('titleEn'),
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      titleEn = val;
                                    });
                                  },
                                ),
                                TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp('[/]')),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: translator.translate('titleAr'),
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      titleAr = val;
                                    });
                                  },
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: translator.translate('txtEn'),
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      messageEn = val;
                                    });
                                  },
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: translator.translate('txtAr'),
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      messageAr = val;
                                    });
                                  },
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: translator.translate('link'),
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      linkUrl = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  translator.translate('cancel'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  translator.translate('send'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: kPrimaryLightColor),
                                ),
                                onPressed: () {
                                  if (titleEn != null &&
                                      titleAr != null &&
                                      messageAr != null &&
                                      messageEn != null) {
                                    return DialogBackground(
                                      color: Colors.black.withOpacity(.2),
                                      blur: 0.5,
                                      dialog: AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side:
                                                BorderSide(color: Colors.grey)),
                                        title: Text(translator
                                            .translate('sureSendthis')),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              translator.translate('cancel'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                    color: Colors.red,
                                                  ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              translator.translate('send'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                    color: kPrimaryLightColor,
                                                  ),
                                            ),
                                            onPressed: () {
                                              addNotifications(
                                                  titleEn: titleEn,
                                                  titleAr: titleAr,
                                                  messageAr: messageAr,
                                                  messageEn: messageEn,
                                                  link: linkUrl != null
                                                      ? linkUrl
                                                      : "null");
                                              Navigator.of(context).pop();
                                              titleEn = null;
                                              titleAr = null;
                                              messageAr = null;
                                              messageEn = null;
                                              linkUrl = null;

                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ).show(context);
                                  } else {
                                    return Fluttertoast.showToast(
                                        msg: translator
                                            .translate('completeNotif'),
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIos: 5,
                                        backgroundColor:
                                            Colors.red[600].withOpacity(0.9),
                                        textColor: Colors.white,
                                        fontSize: 20.0);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ).show(context);
                    },
                  ),
                ),
              ),

              // List of Services...............................................................
              Expanded(
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("Notifications")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot =
                                snapshot.data.documents[index];

                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        translator.currentLanguage == 'en'
                                            ? Text(
                                                documentSnapshot['titleEn'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                              )
                                            : Text(
                                                documentSnapshot['titleAr'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                              ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        translator.currentLanguage == 'en'
                                            ? GestureDetector(
                                                onTap: () {
                                                  _launchURL(
                                                      documentSnapshot['link']);
                                                },
                                                child: Text(
                                                  documentSnapshot['messageEn'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color:
                                                              kPrimaryLightColor,
                                                          fontSize: 14),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  _launchURL(
                                                      documentSnapshot['link']);
                                                },
                                                child: Text(
                                                  documentSnapshot['messageAr'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color:
                                                              kPrimaryLightColor,
                                                          fontSize: 14),
                                                ),
                                              ),
                                      ],
                                    ),
                                    leading: Container(
                                      width: size.width * 0.08,
                                      height: size.height,
                                      child: Icon(
                                        Icons.notifications,
                                        size: 40,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              )
            ],
          )),
    );
  }
}
