import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';

class ServiceList extends StatefulWidget {
  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  TextEditingController editingController = TextEditingController();
  FirebaseUser user;
  String userNation;

  ///////////////////////// Search Function ///////////////////////////////////

  var tempSearchStore = [];
  @override
  initState() {
    if (translator.currentLanguage == 'en') {
      Firestore.instance
          .collection('services')
          .orderBy('name_en')
          .getDocuments()
          .then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          setState(() {
            if (!tempSearchStore.contains(docs.documents[i].data)) {
              tempSearchStore.add(docs.documents[i].data);
              print('add init ${docs.documents[i].data}');
            }
          });
        }
      });
    } else {
      Firestore.instance
          .collection('services')
          .orderBy('name_ar')
          .getDocuments()
          .then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          setState(() {
            if (!tempSearchStore.contains(docs.documents[i].data)) {
              tempSearchStore.add(docs.documents[i].data);
              print('add init ${docs.documents[i].data}');
            }
          });
        }
      });
    }
    detectNation();
    super.initState();
  }

  detectNation() async {
    user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('users')
        .document(user.phoneNumber)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        setState(() {
          userNation = documentSnapshot.data['country'];
          print(userNation);
        });
      }
    });
  }

  initiateSearch(String value) async {
    setState(() {
      tempSearchStore = [];
    });

    if (translator.currentLanguage == 'en') {
      await Firestore.instance
          .collection('services')
          .orderBy('name_en')
          .getDocuments()
          .then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          if (docs.documents[i].data['name_en']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase())) {
            setState(() {
              if (!tempSearchStore.contains(docs.documents[i].data)) {
                tempSearchStore.add(docs.documents[i].data);
                print('add en ${docs.documents[i].data}');
              }
            });
          }
        }
      });
    } else if (translator.currentLanguage == 'ar') {
      await Firestore.instance
          .collection('services')
          .orderBy('name_ar')
          .getDocuments()
          .then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          if (docs.documents[i].data['name_ar']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase())) {
            setState(() {
              if (!tempSearchStore.contains(docs.documents[i].data)) {
                tempSearchStore.add(docs.documents[i].data);
                print('add ar ${docs.documents[i].data}');
              }
            });
          }
        }
      });
    }
  }

  ///////////////////////////// End of Search Function /////////////////////////////////

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translator.translate('book_services')),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // List of Services...............................................................
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 5, right: 5, bottom: 10),
                        child: Column(
                          children: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ServiceList(),
                                  ),
                                );
                              },
                              splashColor: Colors.grey,
                              child: Container(
                                height: size.height * 0.15,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0.0, 2.0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image(
                                        width: size.width * 0.2,
                                        image: AssetImage(
                                          'assets/icons/services.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15.0, bottom: 8),
                                          child: Text(
                                              translator.translate('services'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                translator.translate('homeps1'),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                translator.translate('homeps2'),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
