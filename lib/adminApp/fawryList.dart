import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ndialog/ndialog.dart';
import 'package:sphinx/components/constants.dart';

class FawryList extends StatefulWidget {
  @override
  _FawryListState createState() => _FawryListState();
}

class _FawryListState extends State<FawryList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final DateFormat dateorderFormat = DateFormat('yyyyMMddkkmmss');

    return Scaffold(
      appBar: AppBar(
        title: Text(translator.translate('fawryReq')),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        color: Colors.grey[200],
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("fawryRequests")
              .where('state', isEqualTo: 0)
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: documentSnapshot['about'] == 'service'
                                  ? ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            documentSnapshot['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          Text(
                                            translator.translate('mob') +
                                                ': ' +
                                                documentSnapshot['phone']
                                                    .toString()
                                                    .split('')
                                                    .getRange(2, 13)
                                                    .join()
                                                    .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  fontSize: 18,
                                                ),
                                          ),
                                          translator.currentLanguage == 'en'
                                              ? Text(
                                                  documentSnapshot[
                                                      'serviceNameEn'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        fontSize: 18,
                                                      ),
                                                )
                                              : Text(
                                                  documentSnapshot[
                                                      'serviceNameAr'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        fontSize: 18,
                                                      ),
                                                ),
                                          Text(
                                            translator.translate('fawryId') +
                                                ': ' +
                                                documentSnapshot['fawryId'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          translator.currentLanguage == 'en'
                                              ? Text(
                                                  'Reservation code: ' +
                                                      documentSnapshot['Id'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        color:
                                                            kPrimaryLightColor,
                                                        fontSize: 14,
                                                      ),
                                                )
                                              : Text(
                                                  'كود الحجز: ' +
                                                      documentSnapshot['Id'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        color:
                                                            kPrimaryLightColor,
                                                        fontSize: 14,
                                                      ),
                                                ),
                                          translator.currentLanguage == 'en'
                                              ? Text(
                                                  'Date: ' +
                                                      documentSnapshot['date'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        color: kPrimaryColor,
                                                        fontSize: 14,
                                                      ),
                                                )
                                              : Text(
                                                  'الموعد: ' +
                                                      documentSnapshot['date'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        color: kPrimaryColor,
                                                        fontSize: 14,
                                                      ),
                                                ),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                                icon: CircleAvatar(
                                                  radius: 14,
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  child: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                                onPressed: () {
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
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          FlatButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            splashColor:
                                                                Colors.grey,
                                                            color: Colors.red,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .white)),
                                                            child: Text(
                                                              translator
                                                                  .translate(
                                                                      'delete'),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                            ),
                                                            onPressed: () {
                                                              DialogBackground(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .2),
                                                                blur: 0.5,
                                                                dialog:
                                                                    AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      side: BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                                  title: Text(translator
                                                                      .translate(
                                                                          'sureDeletethis')),
                                                                  actions: <
                                                                      Widget>[
                                                                    FlatButton(
                                                                      child:
                                                                          Text(
                                                                        translator
                                                                            .translate('cancel'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6
                                                                            .copyWith(
                                                                              color: Colors.red,
                                                                            ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      child:
                                                                          Text(
                                                                        translator
                                                                            .translate('delete'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6
                                                                            .copyWith(
                                                                              color: kPrimaryLightColor,
                                                                            ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Firestore
                                                                            .instance
                                                                            .collection(
                                                                                'fawryRequests')
                                                                            .document(documentSnapshot
                                                                                .documentID)
                                                                            .updateData({
                                                                          'state':
                                                                              2
                                                                        });

                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ).show(context);
                                                            },
                                                          ),
                                                          FlatButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            splashColor:
                                                                Colors.grey,
                                                            color:
                                                                kPrimaryColor,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .white)),
                                                            child: Text(
                                                              translator
                                                                  .translate(
                                                                      'send'),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                            onPressed: () {
                                                              DialogBackground(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .2),
                                                                blur: 0.5,
                                                                dialog:
                                                                    AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      side: BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                                  title: Text(translator
                                                                      .translate(
                                                                          'sureSendthis')),
                                                                  actions: <
                                                                      Widget>[
                                                                    FlatButton(
                                                                      child: Text(
                                                                          translator.translate(
                                                                              'cancel'),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline6
                                                                              .copyWith(
                                                                                color: Colors.red,
                                                                              )),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      child:
                                                                          Text(
                                                                        translator
                                                                            .translate('send'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6
                                                                            .copyWith(color: kPrimaryLightColor),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Firestore
                                                                            .instance
                                                                            .collection(
                                                                                'fawryRequests')
                                                                            .document(documentSnapshot
                                                                                .documentID)
                                                                            .updateData({
                                                                          'state':
                                                                              1
                                                                        });
                                                                        Firestore
                                                                            .instance
                                                                            .collection('BookedServices')
                                                                            .document(dateorderFormat.format(DateTime.now()))
                                                                            .setData({
                                                                          'Id':
                                                                              documentSnapshot['Id'],
                                                                          'serviceNameEn':
                                                                              documentSnapshot['serviceNameEn'],
                                                                          'serviceNameAr':
                                                                              documentSnapshot['serviceNameAr'],
                                                                          'phone':
                                                                              documentSnapshot['phone'],
                                                                          'name':
                                                                              documentSnapshot['name'],
                                                                          'age':
                                                                              documentSnapshot['age'],
                                                                          'gender':
                                                                              documentSnapshot['gender'],
                                                                          'country':
                                                                              documentSnapshot['country'],
                                                                          'cost':
                                                                              documentSnapshot['cost'],
                                                                          'state':
                                                                              0,
                                                                          'collectionEn':
                                                                              documentSnapshot['collectionEn'],
                                                                          'collectionAr':
                                                                              documentSnapshot['collectionAr'],
                                                                          'date':
                                                                              documentSnapshot['date'],
                                                                        });
                                                                        Firestore
                                                                            .instance
                                                                            .collection('messages')
                                                                            .document(dateorderFormat.format(DateTime.now()))
                                                                            .setData({
                                                                          'patientName':
                                                                              documentSnapshot['name'],
                                                                          'patientPhone':
                                                                              documentSnapshot['phone'],
                                                                          'message':
                                                                              'bookServMessage',
                                                                          'code':
                                                                              documentSnapshot['Id'],
                                                                          'serviceEn':
                                                                              documentSnapshot['serviceNameEn'],
                                                                          'serviceAr':
                                                                              documentSnapshot['serviceNameAr'],
                                                                          'date':
                                                                              dateorderFormat.format(DateTime.now())
                                                                        });
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator.of(context)
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
                                    )
                                  :
                                  ///////////////////////// Doctor send ////////////////////////
                                  ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            documentSnapshot['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                          ),
                                          Text(
                                            translator.translate('mob') +
                                                ': ' +
                                                documentSnapshot['phone']
                                                    .toString()
                                                    .split('')
                                                    .getRange(2, 13)
                                                    .join()
                                                    .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(fontSize: 18),
                                          ),
                                          translator.currentLanguage == 'en'
                                              ? Text(
                                                  documentSnapshot[
                                                      'DoctorNameEn'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(fontSize: 18),
                                                )
                                              : Text(
                                                  documentSnapshot[
                                                      'DoctorNameAr'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(fontSize: 18),
                                                ),
                                          Text(
                                            translator.translate('fawryId') +
                                                ': ' +
                                                documentSnapshot['fawryId'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    color: Colors.red,
                                                    fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          translator.currentLanguage == 'en'
                                              ? Text(
                                                  'Reservation code: ' +
                                                      documentSnapshot['Id'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color:
                                                              kPrimaryLightColor,
                                                          fontSize: 14),
                                                )
                                              : Text(
                                                  'كود الحجز: ' +
                                                      documentSnapshot['Id'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color:
                                                              kPrimaryLightColor,
                                                          fontSize: 14),
                                                ),
                                          translator.currentLanguage == 'en'
                                              ? Text(
                                                  'Date: ' +
                                                      documentSnapshot['date'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color: kPrimaryColor,
                                                          fontSize: 14),
                                                )
                                              : Text(
                                                  'الموعد: ' +
                                                      documentSnapshot['date'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color: kPrimaryColor,
                                                          fontSize: 14),
                                                ),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                                icon: CircleAvatar(
                                                  radius: 14,
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  child: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                                onPressed: () {
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
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          FlatButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            splashColor:
                                                                Colors.grey,
                                                            color: Colors.red,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .white)),
                                                            child: Text(
                                                              translator
                                                                  .translate(
                                                                      'delete'),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                            ),
                                                            onPressed: () {
                                                              DialogBackground(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .2),
                                                                blur: 0.5,
                                                                dialog:
                                                                    AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      side: BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                                  title: Text(translator
                                                                      .translate(
                                                                          'sureDeletethis')),
                                                                  actions: <
                                                                      Widget>[
                                                                    FlatButton(
                                                                      child:
                                                                          Text(
                                                                        translator
                                                                            .translate('cancel'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6
                                                                            .copyWith(
                                                                              color: Colors.red,
                                                                            ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      child:
                                                                          Text(
                                                                        translator
                                                                            .translate('delete'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6
                                                                            .copyWith(
                                                                              color: kPrimaryLightColor,
                                                                            ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Firestore
                                                                            .instance
                                                                            .collection(
                                                                                'fawryRequests')
                                                                            .document(documentSnapshot
                                                                                .documentID)
                                                                            .updateData({
                                                                          'state':
                                                                              2
                                                                        });
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ).show(context);
                                                            },
                                                          ),
                                                          FlatButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            splashColor:
                                                                Colors.grey,
                                                            color:
                                                                kPrimaryColor,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .white)),
                                                            child: Text(
                                                              translator
                                                                  .translate(
                                                                      'send'),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                            onPressed: () {
                                                              DialogBackground(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .2),
                                                                blur: 0.5,
                                                                dialog:
                                                                    AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      side: BorderSide(
                                                                          color:
                                                                              Colors.grey)),
                                                                  title: Text(translator
                                                                      .translate(
                                                                          'sureSendthis')),
                                                                  actions: <
                                                                      Widget>[
                                                                    FlatButton(
                                                                      child: Text(
                                                                          translator.translate(
                                                                              'cancel'),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline6
                                                                              .copyWith(
                                                                                color: Colors.red,
                                                                              )),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      child:
                                                                          Text(
                                                                        translator
                                                                            .translate('send'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6
                                                                            .copyWith(color: kPrimaryLightColor),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Firestore
                                                                            .instance
                                                                            .collection(
                                                                                'fawryRequests')
                                                                            .document(documentSnapshot
                                                                                .documentID)
                                                                            .updateData({
                                                                          'state':
                                                                              1
                                                                        });
                                                                        Firestore
                                                                            .instance
                                                                            .collection('requests')
                                                                            .document(dateorderFormat.format(DateTime.now()))
                                                                            .setData({
                                                                          'Id':
                                                                              documentSnapshot['Id'],
                                                                          'DoctorNameEn':
                                                                              documentSnapshot['DoctorNameEn'],
                                                                          'DoctorNameAr':
                                                                              documentSnapshot['DoctorNameAr'],
                                                                          'phone':
                                                                              documentSnapshot['phone'],
                                                                          'name':
                                                                              documentSnapshot['name'],
                                                                          'age':
                                                                              documentSnapshot['age'],
                                                                          'gender':
                                                                              documentSnapshot['gender'],
                                                                          'country':
                                                                              documentSnapshot['country'],
                                                                          'cost':
                                                                              documentSnapshot['cost'],
                                                                          'state':
                                                                              0,
                                                                          'date':
                                                                              documentSnapshot['date'],
                                                                          'imgUrl':
                                                                              documentSnapshot['imgUrl'],
                                                                          'specialtyAr':
                                                                              documentSnapshot['specialtyAr'],
                                                                          'specialtyEn':
                                                                              documentSnapshot['specialtyEn'],
                                                                          'DoctorPhone':
                                                                              documentSnapshot['DoctorPhone'],
                                                                        });
                                                                        Firestore
                                                                            .instance
                                                                            .collection('messages')
                                                                            .document(dateorderFormat.format(DateTime.now()))
                                                                            .setData({
                                                                          'patientName':
                                                                              documentSnapshot['name'],
                                                                          'patientPhone':
                                                                              documentSnapshot['phone'],
                                                                          'message':
                                                                              'reqMessage',
                                                                          'code':
                                                                              'null',
                                                                          'serviceEn':
                                                                              documentSnapshot['DoctorNameEn'],
                                                                          'serviceAr':
                                                                              documentSnapshot['DoctorNameAr'],
                                                                          'date':
                                                                              dateorderFormat.format(DateTime.now())
                                                                        });
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator.of(context)
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
                                    )),
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
