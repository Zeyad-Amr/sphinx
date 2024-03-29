import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/providers/UserDataProvider.dart';

class RequestsList extends StatefulWidget {
  @override
  _RequestsListState createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  DateTime fullselectedDate;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd K:mm a');
  final DateFormat dateorderFormat = DateFormat('yyyyMMddkkmmss');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translator.translate('requests')),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.grey[200],
        child: Consumer<User>(
          builder: (context, currentUser, child) => StreamBuilder(
            stream: Firestore.instance
                .collection("requests")
                .where('DoctorPhone', isEqualTo: currentUser.mobile)
                .where('state', isEqualTo: 0)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
                              title: Text(
                                documentSnapshot['name'],
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translator.translate('mob') +
                                        ': ' +
                                        documentSnapshot['phone']
                                           ,
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
                                color: kPrimaryColor,
                              ),
                              trailing: Container(
                                width: size.width * 0.3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // decline icon ....................................................................
                                    IconButton(
                                      color: Colors.grey,
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                        size: 32,
                                      ),
                                      onPressed: () {
                                        DialogBackground(
                                          color: Colors.black.withOpacity(.2),
                                          blur: 0.5,
                                          dialog: AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: Column(
                                              children: [
                                                Text(
                                                    translator.translate(
                                                        'sureRejectRequest'),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      FlatButton(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        splashColor:
                                                            Colors.grey,
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          translator.translate(
                                                              'back'),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17),
                                                        ),
                                                        color: Colors.red,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      FlatButton(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        splashColor:
                                                            Colors.grey,
                                                        onPressed: () {
                                                          Firestore.instance
                                                              .collection(
                                                                  'requests')
                                                              .document(
                                                                  documentSnapshot
                                                                      .documentID)
                                                              .updateData(
                                                                  {'state': 1});
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          translator.translate(
                                                              'reject'),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17),
                                                        ),
                                                        color: kPrimaryColor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .grey)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ).show(context);
                                      },
                                    ),
                                    //accept icon ...........
                                    IconButton(
                                      color: Colors.grey,
                                      icon: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: kPrimaryColor,
                                          child: Icon(
                                            Icons.done,
                                            color: Colors.white,
                                            size: 18,
                                          )),
                                      onPressed: () {
                                        DialogBackground(
                                          color: Colors.black.withOpacity(.2),
                                          blur: 0.5,
                                          dialog: AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  translator.translate(
                                                      'selectDateTime'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    FlatButton(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      splashColor: Colors.grey,
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        translator
                                                            .translate('back'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17),
                                                      ),
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
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    // select date button ///////////////////////////////////////////////////
                                                    FlatButton(
                                                      color: kPrimaryColor,
                                                      textColor: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      splashColor: Colors.grey,
                                                      child: Text(
                                                        translator.translate(
                                                            'selectDateTimebutton'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17),
                                                      ),
                                                      onPressed: () async {
                                                        final selectedDate =
                                                            await _selectDateTime(
                                                                context);
                                                        if (selectedDate ==
                                                            null) return;

                                                        print(selectedDate);

                                                        final selectedTime =
                                                            await _selectTime(
                                                                context);
                                                        if (selectedTime ==
                                                            null) return;
                                                        print(selectedTime);

                                                        setState(() {
                                                          this.fullselectedDate =
                                                              DateTime(
                                                            selectedDate.year,
                                                            selectedDate.month,
                                                            selectedDate.day,
                                                            selectedTime.hour,
                                                            selectedTime.minute,
                                                          );
                                                        });
                                                        print(selectedDate
                                                            .weekday);
                                                        print(dateFormat.format(
                                                            fullselectedDate));

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
                                                                          20),
                                                            ),
                                                            title: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  translator.translate(
                                                                          'appDateIs') +
                                                                      ' ${dateFormat.format(fullselectedDate)}',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6,
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    FlatButton(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      splashColor:
                                                                          Colors
                                                                              .grey,
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        translator
                                                                            .translate('cancel'),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 17),
                                                                      ),
                                                                      color: Colors
                                                                          .red,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              15),
                                                                          side:
                                                                              BorderSide(color: Colors.white)),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    FlatButton(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      splashColor:
                                                                          Colors
                                                                              .grey,
                                                                      onPressed:
                                                                          () {
                                                                        Firestore
                                                                            .instance
                                                                            .collection('appointments')
                                                                            .document(dateorderFormat.format(DateTime.now()))
                                                                            .setData({
                                                                          'Id':
                                                                              documentSnapshot['Id'],
                                                                          'AppointmentDate': dateFormat
                                                                              .format(fullselectedDate)
                                                                              .toString(),
                                                                          'patientName':
                                                                              documentSnapshot['name'],
                                                                          'patientPhone':
                                                                              documentSnapshot['phone'],
                                                                          'age':
                                                                              documentSnapshot['age'],
                                                                          'gender':
                                                                              documentSnapshot['gender'],
                                                                          'country':
                                                                              documentSnapshot['country'],
                                                                          'DoctorPhone':
                                                                              documentSnapshot['DoctorPhone'],
                                                                          'DoctorNameEn':
                                                                              documentSnapshot['DoctorNameEn'],
                                                                          'DoctorNameAr':
                                                                              documentSnapshot['DoctorNameAr'],
                                                                          'specialtyEn':
                                                                              documentSnapshot['specialtyEn'],
                                                                          'specialtyAr':
                                                                              documentSnapshot['specialtyAr'],
                                                                          'cost':
                                                                              documentSnapshot['cost'],
                                                                          'state':
                                                                              0,
                                                                          'imgUrl':
                                                                              documentSnapshot['imgUrl'],
                                                                        });
                                                                        Firestore
                                                                            .instance
                                                                            .collection(
                                                                                'requests')
                                                                            .document(documentSnapshot
                                                                                .documentID)
                                                                            .updateData({
                                                                          'state':
                                                                              1
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
                                                                              'AppSetMessage',
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
                                                                      child:
                                                                          Text(
                                                                        translator
                                                                            .translate('accept'),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 17),
                                                                      ),
                                                                      color:
                                                                          kPrimaryColor,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              15),
                                                                          side:
                                                                              BorderSide(color: Colors.grey)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ).show(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ).show(context);
                                      },
                                    ),
                                  ],
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
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay> _selectTime(BuildContext context) {
    final now = DateTime.now();

    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: now.hour,
        minute: now.minute,
      ),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
  }

  Future<DateTime> _selectDateTime(BuildContext context) => showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
}
