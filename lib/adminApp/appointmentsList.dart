import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';

class AppointmentsList extends StatefulWidget {
  @override
  _AppointmentsListState createState() => _AppointmentsListState();
}

class _AppointmentsListState extends State<AppointmentsList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.translate('appointments')),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: double.infinity,
          color: Colors.grey[200],
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection("appointments")
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
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        documentSnapshot['patientName'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        documentSnapshot['doctorName'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      Text(
                                        documentSnapshot['cost'] +
                                            translator.translate('L.E'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
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
                                      translator.currentLanguage == 'en'
                                          ? Text(
                                              'Invoice Code: ' +
                                                  documentSnapshot['Id'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            )
                                          : Text(
                                              'كود الفاتورة: ' +
                                                  documentSnapshot['Id'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),

                                      /*  Text(
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
                                                    translator
                                                        .translate('male'),
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
                                               */
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
                              "No items",
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
            ],
          ),
        ),
      ),
    );
  }
}
