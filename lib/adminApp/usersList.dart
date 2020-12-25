import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  setAccount(String mob, String info) async {
    await Firestore.instance
        .collection('users')
        .document(mob)
        .updateData({'info': info});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.translate('users')),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        color: Colors.grey[200],
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .orderBy('info')
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
                                Text(documentSnapshot['name'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 20)),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  documentSnapshot['mobile'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: kPrimaryLightColor,
                                          fontSize: 18),
                                )
                              ],
                            ),
                            leading: Container(
                              width: 60,
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/user.png',
                                ),
                                radius: 30,
                              ),
                            ),
                            trailing: DropdownButton<String>(
                              hint: Text(translator.translate('account')),
                              value: documentSnapshot['info'] == 'admin' ||
                                      documentSnapshot['info'] == 'مشرف'
                                  ? translator.translate('admin')
                                  : documentSnapshot['info'] == 'doctor' ||
                                          documentSnapshot['info'] == 'طبيب'
                                      ? translator.translate('doctor')
                                      : translator.translate('patient'),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                              ),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: kPrimaryColor),
                              underline: Container(
                                height: 2,
                                color: Colors.transparent,
                              ),
                              onChanged: (String newValue) {
                                String infoo;
                                if (newValue == translator.translate('admin')) {
                                  infoo = 'admin';
                                } else if (newValue ==
                                    translator.translate('doctor')) {
                                  infoo = 'doctor';
                                } else if (newValue ==
                                    translator.translate('patient')) {
                                  infoo = 'patient';
                                }
                                setAccount(documentSnapshot['mobile'], infoo);
                              },
                              items: <String>[
                                translator.translate('admin'),
                                translator.translate('doctor'),
                                translator.translate('patient'),
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
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
