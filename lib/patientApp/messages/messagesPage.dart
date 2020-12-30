import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/providers/UserDataProvider.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Timer(Duration(milliseconds: 200), scrollToBottom);
  }

  void scrollToBottom() {
    try {
      final bottomOffset = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        bottomOffset,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      print('scroll to bottom error :: $e ');
    }
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(translator.translate('messages')),
        ),
        body: Container(
          height: size.height,
          width: double.infinity,
          color: Colors.grey[200],
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Text(translator.translate('messages'),
                    style: Theme.of(context).textTheme.headline6),
              ),
              Expanded(
                child: Consumer<User>(
                  builder: (context, currentUser, child) => StreamBuilder(
                    stream: Firestore.instance
                        .collection("messages")
                        .where('patientPhone', isEqualTo: currentUser.mobile)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Timer(Duration(milliseconds: 500), scrollToBottom);
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
                                            color:
                                                Colors.black.withOpacity(0.5)),
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
                            controller: _scrollController,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          translator.currentLanguage == 'en'
                                              ? Text(
                                                  documentSnapshot['serviceEn'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                )
                                              : Text(
                                                  documentSnapshot['serviceAr'],
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
                                          documentSnapshot['code'] != 'null'
                                              ? Text(
                                                  translator.translate(
                                                          documentSnapshot[
                                                              'message']) +
                                                      ' ' +
                                                      documentSnapshot['code'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color:
                                                              kPrimaryLightColor,
                                                          fontSize: 14),
                                                )
                                              : Text(
                                                  translator.translate(
                                                      documentSnapshot[
                                                          'message']),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color:
                                                              kPrimaryLightColor,
                                                          fontSize: 14),
                                                )
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
        ));
  }
}
