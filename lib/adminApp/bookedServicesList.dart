import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ndialog/ndialog.dart';
import 'package:sphinx/components/constants.dart';

class BookedServices extends StatefulWidget {
  @override
  _BookedServicesState createState() => _BookedServicesState();
}

class _BookedServicesState extends State<BookedServices> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.translate('bookedSerives')),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        color: Colors.grey[200],
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("BookedServices")
              .orderBy('state')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length == 0) {
                return Container(
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "No items",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.black.withOpacity(0.5)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.documents[index];

                    return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Card(
                          color: documentSnapshot['state'] == 0
                              ? Colors.white
                              : Colors.red[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  translator.currentLanguage == 'en'
                                      ? Text(
                                          documentSnapshot['serviceNameEn'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                        )
                                      : Text(
                                          documentSnapshot['serviceNameAr'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                        ),
                                  Text(
                                    translator.translate('patientName') +
                                        ': ' +
                                        documentSnapshot['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(fontSize: 18),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  translator.currentLanguage == 'en'
                                      ? Text(
                                          'Reservation code: ' +
                                              documentSnapshot['Id'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  color: kPrimaryLightColor,
                                                  fontSize: 14),
                                        )
                                      : Text(
                                          'كود الحجز: ' +
                                              documentSnapshot['Id'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  color: kPrimaryLightColor,
                                                  fontSize: 14),
                                        ),
                                  translator.currentLanguage == 'en'
                                      ? Text(
                                          'Date: ' + documentSnapshot['date'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  color: kPrimaryColor,
                                                  fontSize: 14),
                                        )
                                      : Text(
                                          'الموعد: ' + documentSnapshot['date'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  color: kPrimaryColor,
                                                  fontSize: 14),
                                        ),
                                  Text(
                                    translator.translate('mob') +
                                        ': ' +
                                        documentSnapshot['phone'],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  translator.currentLanguage == 'en'
                                      ? Text(
                                          'Country: ' +
                                              documentSnapshot['country'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )
                                      : Text(
                                          'البلد: ' +
                                              documentSnapshot['country'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                  Text(
                                    translator.translate('cost') +
                                        ' ' +
                                        documentSnapshot['cost'].toString() +
                                        ' ' +
                                        translator.translate('L.E'),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    translator.translate('age') +
                                        ': ' +
                                        documentSnapshot['age'],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  documentSnapshot['gender'] == 'Male' ||
                                          documentSnapshot['gender'] == 'ذكر'
                                      ? Text(
                                          translator.translate('gender') +
                                              ': ' +
                                              translator.translate('male'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )
                                      : Text(
                                          translator.translate('gender') +
                                              ': ' +
                                              translator.translate('female'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )
                                ],
                              ),
                              leading: Container(
                                width: size.width * 0.08,
                                height: size.height,
                                child: Icon(
                                  Icons.date_range,
                                  size: 40,
                                  color: kPrimaryColor,
                                ),
                              ),
                              trailing: Container(
                                height: 70,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        icon: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: kPrimaryColor,
                                          child: Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                        onPressed: () {
                                          DialogBackground(
                                            color: Colors.black.withOpacity(.2),
                                            blur: 0.5,
                                            dialog: AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  side: BorderSide(
                                                      color: Colors.grey)),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  FlatButton(
                                                    padding: EdgeInsets.all(10),
                                                    splashColor: Colors.grey,
                                                    color: Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white)),
                                                    child: Text(
                                                      translator
                                                          .translate('cancel'),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  FlatButton(
                                                    padding: EdgeInsets.all(10),
                                                    splashColor: Colors.grey,
                                                    color: kPrimaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white)),
                                                    child: Text(
                                                      translator
                                                          .translate('end'),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    onPressed: () {
                                                      DialogBackground(
                                                        color: Colors.black
                                                            .withOpacity(.2),
                                                        blur: 0.5,
                                                        dialog: AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                          title: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(translator
                                                                .translate(
                                                                    'sureEnd')),
                                                          ),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              child: Text(
                                                                  translator
                                                                      .translate(
                                                                          'cancel'),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6
                                                                      .copyWith(
                                                                        color: Colors
                                                                            .red,
                                                                      )),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text(
                                                                translator
                                                                    .translate(
                                                                        'end'),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline6
                                                                    .copyWith(
                                                                        color:
                                                                            kPrimaryLightColor),
                                                              ),
                                                              onPressed: () {
                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'BookedServices')
                                                                    .document(
                                                                        documentSnapshot
                                                                            .documentID)
                                                                    .updateData({
                                                                  'state': 1
                                                                });

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ).show(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ).show(context);
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                ),
              );
            } else {
              return Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.3,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "No items",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.black.withOpacity(0.5)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
