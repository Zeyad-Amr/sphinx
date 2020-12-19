import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';

import 'detail_screen.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  TextEditingController editingController = TextEditingController();
  FirebaseUser user;
  String userNation;

  ///////////////////////// Search Function ///////////////////////////////////

  var tempSearchStore = [];
  @override
  initState() {
    Firestore.instance
        .collection('doctors')
        .orderBy('order')
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
          .collection('doctors')
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
          .collection('doctors')
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
        title: Text(translator.translate('book_doctors')),
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
                    // List of Doctors...............................................................
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
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
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        translator.currentLanguage == 'en'
                                            ? Text(
                                                documentSnapshot['specialtyEn'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold))
                                            : Text(
                                                documentSnapshot['specialtyAr'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2),
                                        userNation == 'مصر‎'
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Text(
                                                    translator.translate(
                                                            'Ccost') +
                                                        ' ' +
                                                        documentSnapshot[
                                                                'costEgy']
                                                            .toString() +
                                                        ' ' +
                                                        translator
                                                            .translate('L.E'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Text(
                                                    translator.translate(
                                                            'Ccost') +
                                                        ' ' +
                                                        documentSnapshot[
                                                                'costForg']
                                                            .toString() +
                                                        ' ' +
                                                        translator
                                                            .translate('L.E'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2),
                                              ),
                                      ],
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
                                      width: 60,
                                      child: documentSnapshot['imgUrl'] != null
                                          ? CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                documentSnapshot['imgUrl'],
                                              ),
                                              radius: 30,
                                            )
                                          : CircleAvatar(
                                              backgroundColor: kPrimaryColor,
                                              radius: 30,
                                            ),
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
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                              docNameEn:
                                                  documentSnapshot['name_en'],
                                              docNameAr:
                                                  documentSnapshot['name_ar'],
                                              descriptionEn: documentSnapshot[
                                                  'specialtyEn'],
                                              descriptionAr: documentSnapshot[
                                                  'specialtyAr'],
                                              imageUrl:
                                                  documentSnapshot['imgUrl'],
                                              cost: userNation == 'مصر‎'
                                                  ? documentSnapshot['costEgy']
                                                  : documentSnapshot[
                                                      'costForg'],
                                              docMobile:
                                                  documentSnapshot['mobile'],
                                            ),
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
