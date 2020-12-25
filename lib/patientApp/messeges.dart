import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/providers/UserDataProvider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MessegesWidget extends StatefulWidget {
  const MessegesWidget({
    Key key,
  }) : super(key: key);

  @override
  _MessegesWidgetState createState() => _MessegesWidgetState();
}

class _MessegesWidgetState extends State<MessegesWidget> {
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
            child: Text(translator.translate('messages'),
                style: Theme.of(context).textTheme.headline6),
          ),
          Expanded(
            child: Consumer<User>(
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
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      translator.currentLanguage == 'en'
                                          ? Text(
                                              documentSnapshot['DoctorNameEn'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                            )
                                          : Text(
                                              documentSnapshot['DoctorNameAr'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
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
                                              'Date: ' +
                                                  documentSnapshot[
                                                      'AppointmentDate'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      color: kPrimaryColor,
                                                      fontSize: 14),
                                            )
                                          : Text(
                                              'الموعد: ' +
                                                  documentSnapshot[
                                                      'AppointmentDate'],
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
                                      Icons.message,
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
