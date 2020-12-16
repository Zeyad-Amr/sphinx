import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/providers/UserDataProvider.dart';

import 'messages/messageDetailsScreen.dart';

class MessegesWidget extends StatefulWidget {
  const MessegesWidget({
    Key key,
  }) : super(key: key);

  @override
  _MessegesWidgetState createState() => _MessegesWidgetState();
}

class _MessegesWidgetState extends State<MessegesWidget> {
  int i = 1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: size.height,
        width: double.infinity,
        color: Colors.grey[200],
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Text('My Messages',
                  style: Theme.of(context).textTheme.headline6),
            ),
            Consumer<User>(
              builder: (context, currentUser, child) => StreamBuilder(
                stream: Firestore.instance
                    .collection("appointments")
                    .where('patientPhone', isEqualTo: currentUser.mobile)
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
                                "You haven't any messages",
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
                                            MessageDetailsScreen(
                                          doctorName:
                                              documentSnapshot['DoctorName'],
                                          imageUrl: documentSnapshot['imgUrl'],
                                          doctorPhone:
                                              documentSnapshot['DoctorPhone'],
                                          pateintPhone:
                                              documentSnapshot['patientPhone'],
                                        ),
                                      ));
                                    },
                                    child: Text('open'),
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
                                        documentSnapshot['DoctorName'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      Text(
                                        'Date: ' +
                                            documentSnapshot['AppointmentDate'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                color: kPrimaryLightColor),
                                      ),
                                    ],
                                  ),
                                  /* subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      
                                      Text(
                                        translator.translate('mob') +
                                            ': ' +
                                            documentSnapshot['patientPhone']
                                                .toString()
                                                .split('')
                                                .getRange(2, 13)
                                                .join()
                                                .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
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
                              "You haven't any messages",
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
          ],
        ),
      ),
    );
  }
}
