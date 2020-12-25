import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ndialog/ndialog.dart';
import 'package:sphinx/components/constants.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:sphinx/providers/UserDataProvider.dart';
import 'package:sphinx/screens/loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RadiologyList extends StatefulWidget {
  @override
  _RadiologyListState createState() => _RadiologyListState();
}

class _RadiologyListState extends State<RadiologyList> {
  TextEditingController editingController = TextEditingController();
  FirebaseUser user;
  String userNation;
  int cost;
  uniqueId() {
    String uniqueId =
        UniqueKey().toString().split('').getRange(2, 7).join().toString() +
            UniqueKey().toString().split('').getRange(2, 7).join().toString() +
            UniqueKey().toString().split('').getRange(2, 7).join().toString();
    return uniqueId;
  }

  ///////////////////////// Search Function ///////////////////////////////////

  var tempSearchStore = [];
  @override
  initState() {
    if (translator.currentLanguage == 'en') {
      Firestore.instance
          .collection('services_collections/collections/radiology')
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
          .collection('services_collections/collections/radiology')
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
          .collection('services_collections/collections/radiology')
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
          .collection('services_collections/collections/radiology')
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
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd K:mm a');
    final DateFormat dateorderFormat = DateFormat('yyyyMMddkkmm');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translator.translate('radiology')),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.grey[200],
        child: Consumer<User>(
          builder: (context, currentUser, child) => Column(
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                    .bodyText1
                                                    .copyWith(
                                                        color:
                                                            kPrimaryLightColor,
                                                        fontSize: 14),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                translator.translate('cost') +
                                                    ' ' +
                                                    documentSnapshot['costForg']
                                                        .toString() +
                                                    ' ' +
                                                    translator.translate('L.E'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color:
                                                            kPrimaryLightColor,
                                                        fontSize: 14),
                                              ),
                                            ),
                                      title: translator.currentLanguage == 'en'
                                          ? Text(
                                              documentSnapshot['name_en'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                            )
                                          : Text(
                                              documentSnapshot['name_ar'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                            ),
                                      leading: Container(
                                        width: size.width * 0.08,
                                        height: size.height,
                                        color: kPrimaryColor,
                                      ),
                                      trailing: FlatButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        color: kPrimaryColor,
                                        textColor: Colors.white,
                                        child: Text(
                                          translator.translate('book'),
                                        ),
                                        onPressed: () {
                                          if (userNation == 'مصر‎') {
                                            setState(() {
                                              cost =
                                                  documentSnapshot['costEgy'];
                                            });
                                            print('cost is $cost');
                                          } else {
                                            setState(() {
                                              cost =
                                                  documentSnapshot['costForg'];
                                            });
                                            print('cost is $cost');
                                          }
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                FancyDialog(
                                              theme: 1,
                                              descreption: userNation == 'مصر‎'
                                                  ? translator
                                                          .translate('cost') +
                                                      ' ' +
                                                      documentSnapshot[
                                                              'costEgy']
                                                          .toString() +
                                                      ' ' +
                                                      translator
                                                          .translate('L.E')
                                                  : translator
                                                          .translate('cost') +
                                                      ' ' +
                                                      documentSnapshot[
                                                              'costForg']
                                                          .toString() +
                                                      ' ' +
                                                      translator
                                                          .translate('L.E'),
                                              title: translator
                                                          .currentLanguage ==
                                                      'en'
                                                  ? documentSnapshot['name_en']
                                                  : documentSnapshot['name_ar'],
                                              gifPath:
                                                  'assets/images/serviceList2.png',
                                              ok: translator.translate('book'),
                                              cancel: translator
                                                  .translate('cancel'),
                                              cancelColor: Colors.black,
                                              okColor: kPrimaryColor,
                                              okFun: () {
                                                ////////////////////////////Book Function ////////////////////
                                                String id = uniqueId();
                                                print(id);

                                                DialogBackground(
                                                  color: Colors.black
                                                      .withOpacity(.2),
                                                  blur: 0.5,
                                                  dialog: AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .grey)),
                                                    actions: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            FlatButton(
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/visa.png',
                                                                width:
                                                                    size.width *
                                                                        0.3,
                                                              ),
                                                              onPressed: () {
                                                                /////////////////// Visa Payment ///////////////////////////

                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            WebView(
                                                                      onPageStarted:
                                                                          (input) {},
                                                                      onPageFinished:
                                                                          (output) {
                                                                        print(
                                                                            'Paaaayymmeeeeeeeeeeeeeeeeeeeeeeent');
                                                                        print(
                                                                            output);
                                                                        if (output
                                                                            .contains('NBESuccess.php')) {
                                                                          Firestore
                                                                              .instance
                                                                              .collection('BookedServices')
                                                                              .document(dateorderFormat.format(DateTime.now()))
                                                                              .setData({
                                                                            'Id':
                                                                                id,
                                                                            'serviceNameEn':
                                                                                documentSnapshot['name_en'],
                                                                            'serviceNameAr':
                                                                                documentSnapshot['name_ar'],
                                                                            'phone':
                                                                                currentUser.mobile,
                                                                            'name':
                                                                                currentUser.name,
                                                                            'age':
                                                                                currentUser.age,
                                                                            'gender':
                                                                                currentUser.gender,
                                                                            'country':
                                                                                currentUser.country,
                                                                            'cost': userNation == 'مصر‎'
                                                                                ? documentSnapshot['costEgy']
                                                                                : documentSnapshot['costForg'],
                                                                            'state':
                                                                                0,
                                                                            'collectionEn':
                                                                                'Radiology',
                                                                            'collectionAr':
                                                                                'الإشعة',
                                                                            'date':
                                                                                dateFormat.format(DateTime.now()),
                                                                          });
                                                                          Firestore
                                                                              .instance
                                                                              .collection('messages')
                                                                              .document(dateorderFormat.format(DateTime.now()))
                                                                              .setData({
                                                                            'patientName':
                                                                                currentUser.name,
                                                                            'patientPhone':
                                                                                currentUser.mobile,
                                                                            'message':
                                                                                'bookServMessage',
                                                                            'code':
                                                                                id,
                                                                            'serviceEn':
                                                                                documentSnapshot['name_en'],
                                                                            'serviceAr':
                                                                                documentSnapshot['name_ar'],
                                                                            'date':
                                                                                dateorderFormat.format(DateTime.now())
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Fluttertoast.showToast(
                                                                              msg: translator.translate('successPay'),
                                                                              toastLength: Toast.LENGTH_LONG,
                                                                              gravity: ToastGravity.TOP,
                                                                              timeInSecForIos: 5,
                                                                              backgroundColor: Colors.green.withOpacity(0.6),
                                                                              textColor: Colors.white,
                                                                              fontSize: 20.0);
                                                                        } else if (output
                                                                            .contains('NBEFailed.php')) {
                                                                          print(
                                                                              'OUTPUT IS ................. $output');
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Fluttertoast.showToast(
                                                                              msg: translator.translate('failedPay'),
                                                                              toastLength: Toast.LENGTH_LONG,
                                                                              gravity: ToastGravity.TOP,
                                                                              timeInSecForIos: 5,
                                                                              backgroundColor: Colors.red.withOpacity(0.6),
                                                                              textColor: Colors.white,
                                                                              fontSize: 20.0);
                                                                        } else if (output
                                                                            .contains('NBECancel.php')) {
                                                                          print(
                                                                              'OUTPUT IS ................. $output');
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Fluttertoast.showToast(
                                                                              msg: translator.translate('canceledPay'),
                                                                              toastLength: Toast.LENGTH_LONG,
                                                                              gravity: ToastGravity.TOP,
                                                                              timeInSecForIos: 5,
                                                                              backgroundColor: Colors.red.withOpacity(0.6),
                                                                              textColor: Colors.white,
                                                                              fontSize: 20.0);
                                                                        }
                                                                      },
                                                                      initialUrl:
                                                                          "https://onlineconsultation.sphinxkc.com/NBEPayment.php?s_name=${documentSnapshot['name_en']}&s_price=$cost&OID=$id",
                                                                      javascriptMode:
                                                                          JavascriptMode
                                                                              .unrestricted,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/fawry.png',
                                                                width:
                                                                    size.width *
                                                                        0.3,
                                                              ),
                                                              onPressed: () {
                                                                /////////////////// Fawry Payment ///////////////////////////

                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            WebView(
                                                                      onPageStarted:
                                                                          (input) {},
                                                                      onPageFinished:
                                                                          (output) {
                                                                        print(
                                                                            'Paaaayymmeeeeeeeeeeeeeeeeeeeeeeent');
                                                                        print(
                                                                            output);
                                                                        if (output
                                                                            .contains('FawrySuccess.php')) {
                                                                          Firestore
                                                                              .instance
                                                                              .collection('fawryRequests')
                                                                              .document(dateorderFormat.format(DateTime.now()))
                                                                              .setData({
                                                                            'Id':
                                                                                id,
                                                                            'serviceNameEn':
                                                                                documentSnapshot['name_en'],
                                                                            'serviceNameAr':
                                                                                documentSnapshot['name_ar'],
                                                                            'phone':
                                                                                currentUser.mobile,
                                                                            'name':
                                                                                currentUser.name,
                                                                            'age':
                                                                                currentUser.age,
                                                                            'gender':
                                                                                currentUser.gender,
                                                                            'country':
                                                                                currentUser.country,
                                                                            'cost': userNation == 'مصر‎'
                                                                                ? documentSnapshot['costEgy']
                                                                                : documentSnapshot['costForg'],
                                                                            'state':
                                                                                0,
                                                                            'collectionEn':
                                                                                'Radiology',
                                                                            'collectionAr':
                                                                                'الإشعة',
                                                                            'date':
                                                                                dateFormat.format(DateTime.now()),
                                                                            'fawryId': output.replaceRange(
                                                                                0,
                                                                                72,
                                                                                ''),
                                                                            'about':
                                                                                'service'
                                                                          });
                                                                          Firestore
                                                                              .instance
                                                                              .collection('messages')
                                                                              .document(dateorderFormat.format(DateTime.now()))
                                                                              .setData({
                                                                            'patientName':
                                                                                currentUser.name,
                                                                            'patientPhone':
                                                                                currentUser.mobile,
                                                                            'message':
                                                                                'fawryMessage',
                                                                            'code': output.replaceRange(
                                                                                0,
                                                                                72,
                                                                                ''),
                                                                            'serviceEn':
                                                                                documentSnapshot['name_en'],
                                                                            'serviceAr':
                                                                                documentSnapshot['name_ar'],
                                                                            'date':
                                                                                dateorderFormat.format(DateTime.now())
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Fluttertoast.showToast(
                                                                              msg: translator.translate('successPay'),
                                                                              toastLength: Toast.LENGTH_LONG,
                                                                              gravity: ToastGravity.TOP,
                                                                              timeInSecForIos: 5,
                                                                              backgroundColor: Colors.green.withOpacity(0.6),
                                                                              textColor: Colors.white,
                                                                              fontSize: 20.0);
                                                                        } else if (output
                                                                            .contains('FawryFailed.php')) {
                                                                          print(
                                                                              'OUTPUT IS ................. $output');
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Fluttertoast.showToast(
                                                                              msg: translator.translate('failedPay'),
                                                                              toastLength: Toast.LENGTH_LONG,
                                                                              gravity: ToastGravity.TOP,
                                                                              timeInSecForIos: 5,
                                                                              backgroundColor: Colors.red.withOpacity(0.6),
                                                                              textColor: Colors.white,
                                                                              fontSize: 20.0);
                                                                        }
                                                                      },
                                                                      initialUrl:
                                                                          "http://onlineconsultation.sphinxkc.com/FawryPayment.php?s_name=${documentSnapshot['name_en']}&s_price=$cost&OID=$id&cstmail=${currentUser.email}&cstPhone=${currentUser.mobile.toString().split('').getRange(2, 13).join().toString()}&cstID=${currentUser.mobile.toString().split('').getRange(2, 13).join().toString()}",
                                                                      javascriptMode:
                                                                          JavascriptMode
                                                                              .unrestricted,
                                                                    ),
                                                                  ),
                                                                );

                                                                /*  print(
                                                                    "YYY:http://onlineconsultation.sphinxkc.com/FawryPayment.php?s_name=${documentSnapshot['name_en']}&s_price=$cost&OID=$id&cstmail=${currentUser.email}&cstPhone=${currentUser.mobile.toString().split('').getRange(2, 13).join().toString()}&cstID=${currentUser.mobile.toString().split('').getRange(2, 13).join().toString()}"); */
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ).show(context);
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoadingScreen()));
                                              },
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
      ),
    );
  }
}
