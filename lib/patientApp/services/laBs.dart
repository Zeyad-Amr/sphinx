import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';

class LabsList extends StatefulWidget {
  @override
  _LabsListState createState() => _LabsListState();
}

class _LabsListState extends State<LabsList> {
  TextEditingController editingController = TextEditingController();
  FirebaseUser user;
  String userNation;

  ///////////////////////// Search Function ///////////////////////////////////

  var tempSearchStore = [];
  @override
  initState() {
    if (translator.currentLanguage == 'en') {
      Firestore.instance
          .collection('services_collections/collections/labs')
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
          .collection('services_collections/collections/labs')
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
          .collection('services_collections/collections/labs')
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
          .collection('services_collections/collections/labs')
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
        title: Text(translator.translate('labs')),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.grey[200],
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: TextField(
                onChanged: (value) {
                  initiateSearch(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: translator.translate('search'),
                    hintText: translator.translate('search'),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // List of Services...............................................................
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: tempSearchStore.length,
                          itemBuilder: (context, index) {
                            var documentSnapshot = tempSearchStore[index];

                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListTile(
                                    subtitle: userNation == 'مصر‎'
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                                translator.translate('cost') +
                                                    ' ' +
                                                    documentSnapshot['costEgy']
                                                        .toString() +
                                                    ' ' +
                                                    translator.translate('L.E'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              translator.translate('cost') +
                                                  ' ' +
                                                  documentSnapshot['costForg']
                                                      .toString() +
                                                  ' ' +
                                                  translator.translate('L.E'),
                                            ),
                                          ),
                                    title: translator.currentLanguage == 'en'
                                        ? Text(
                                            documentSnapshot['name_en'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          )
                                        : Text(
                                            documentSnapshot['name_ar'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                    leading: Container(
                                      width: size.width * 0.08,
                                      height: size.height,
                                      color: kPrimaryColor,
                                    ),
                                    trailing: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      color: kPrimaryColor,
                                      textColor: Colors.white,
                                      child: Text(
                                        translator.translate('book'),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              FancyDialog(
                                            theme: 1,
                                            descreption: userNation == 'مصر‎'
                                                ? translator.translate('cost') +
                                                    ' ' +
                                                    documentSnapshot['costEgy']
                                                        .toString() +
                                                    ' ' +
                                                    translator.translate('L.E')
                                                : translator.translate('cost') +
                                                    ' ' +
                                                    documentSnapshot['costForg']
                                                        .toString() +
                                                    ' ' +
                                                    translator.translate('L.E'),
                                            title: translator.currentLanguage ==
                                                    'en'
                                                ? documentSnapshot['name_en']
                                                : documentSnapshot['name_ar'],
                                            gifPath:
                                                'assets/images/serviceList.png',
                                            ok: translator.translate('book'),
                                            cancel:
                                                translator.translate('cancel'),
                                            cancelColor: Colors.black,
                                            okColor: kPrimaryColor,
                                            okFun: () {},
                                            animationType:
                                                FancyAnimation.TOP_BOTTOM,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
