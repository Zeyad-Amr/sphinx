/* /*  */import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';

class EndedAppointmentsList extends StatefulWidget {
  @override
  _EndedAppointmentsListState createState() => _EndedAppointmentsListState();
}

class _EndedAppointmentsListState extends State<EndedAppointmentsList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.translate('EndedConsult')),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        color: Colors.grey[200],
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("appointments")
              .where('state', isEqualTo: 1)
              .orderBy('endDate', descending: true)
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
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                translator.currentLanguage == 'en'
                                    ? Text(
                                        documentSnapshot['DoctorNameEn'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        documentSnapshot['DoctorNameAr'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
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
                                            .headline6
                                            .copyWith(
                                                color: kPrimaryLightColor),
                                      )
                                    : Text(
                                        'كود الحجز: ' + documentSnapshot['Id'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                color: kPrimaryLightColor),
                                      ),
                                translator.currentLanguage == 'en'
                                    ? Text(
                                        'Date: ' +
                                            documentSnapshot['AppointmentDate'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(color: kPrimaryColor),
                                      )
                                    : Text(
                                        'الموعد: ' +
                                            documentSnapshot['AppointmentDate'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(color: kPrimaryColor),
                                      ),
                                translator.currentLanguage == 'en'
                                    ? Text(
                                        'End Date: ' +
                                            documentSnapshot['endDate'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(color: Colors.red[700]),
                                      )
                                    : Text(
                                        'موعد الإنتهاء: ' +
                                            documentSnapshot['endDate'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                color: kPrimaryLightColor),
                                      ),
                                Text(
                                  translator.translate('patientName') +
                                      ': ' +
                                      documentSnapshot['patientName'],
                                  style: Theme.of(context).textTheme.headline6,
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
                                  style: Theme.of(context).textTheme.bodyText1,
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
                                        'البلد: ' + documentSnapshot['country'],
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
                                  style: Theme.of(context).textTheme.bodyText1,
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
 */
