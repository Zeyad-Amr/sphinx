import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/providers/UserDataProvider.dart';

import 'messages/messageDetailsDoctorScreen.dart';

class AppointmentWidgetDoctor extends StatefulWidget {
  const AppointmentWidgetDoctor({
    Key key,
  }) : super(key: key);

  @override
  _AppointmentWidgetDoctorState createState() =>
      _AppointmentWidgetDoctorState();
}

class _AppointmentWidgetDoctorState extends State<AppointmentWidgetDoctor> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: Text(translator.translate('appointments'),
                style: Theme.of(context).textTheme.headline6),
          ),
          Expanded(
            child: Consumer<User>(
              builder: (context, currentUser, child) => StreamBuilder(
                stream: Firestore.instance
                    .collection("appointments")
                    .where('DoctorPhone', isEqualTo: currentUser.mobile)
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
                                translator.translate('noItems'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        color: Colors.black.withOpacity(0.5)),
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
                                  trailing: RaisedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            MessageDetailsDoctorScreen(
                                          imageUrl: documentSnapshot['imgUrl'],
                                          documentId:
                                              documentSnapshot.documentID,
                                          age: documentSnapshot['age'],
                                          country: documentSnapshot['country'],
                                          gender: documentSnapshot['gender'],
                                          doctorNameEn:
                                              documentSnapshot['DoctorNameEn'],
                                          doctorNameAr:
                                              documentSnapshot['DoctorNameAr'],
                                          doctorPhone:
                                              documentSnapshot['DoctorPhone'],
                                          pateintPhone:
                                              documentSnapshot['patientPhone'],
                                          patientName:
                                              documentSnapshot['patientName'],
                                        ),
                                      ));
                                    },
                                    child: Text(translator.translate('open')),
                                    color: kPrimaryColor,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        documentSnapshot['patientName'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      )
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
                                                          kPrimaryLightColor),
                                            )
                                          : Text(
                                              'كود الحجز: ' +
                                                  documentSnapshot['Id'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      color:
                                                          kPrimaryLightColor),
                                            ),
                                      translator.currentLanguage == 'en'
                                          ? Text(
                                              'Date: ' +
                                                  documentSnapshot[
                                                      'AppointmentDate'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      color: kPrimaryColor),
                                            )
                                          : Text(
                                              'الموعد: ' +
                                                  documentSnapshot[
                                                      'AppointmentDate'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      color: kPrimaryColor),
                                            ),
                                      Text(
                                        translator.translate('mob') +
                                            ': ' +
                                            documentSnapshot['patientPhone']
                                               ,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  ),
                                  /* subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      
                                     
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
                                        translator.translate('age') +
                                            ': ' +
                                            documentSnapshot['age'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      documentSnapshot['gender'] == 'Male' ||
                                              documentSnapshot['gender'] ==
                                                  'ذكر'
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
                                                  translator
                                                      .translate('female'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            )
                                    ],
                                  ), */
                                  leading: Container(
                                    width: size.width * 0.08,
                                    height: size.height,
                                    child: Icon(
                                      Icons.date_range,
                                      size: 40,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  /*      trailing: Container(
                                    width: size.width * 0.3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          documentSnapshot['AppointmentDate'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  color: kPrimaryLightColor),
                                        ),
                                      ],
                                    ),
                                  ), */
                                ),
                              ),
                            ),
                          );
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
                              translator.translate('noItems'),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Colors.black.withOpacity(0.5)),
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
          ),
        ],
      ),
    );
  }
}
