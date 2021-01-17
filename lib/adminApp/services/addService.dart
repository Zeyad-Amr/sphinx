import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';

class AddService extends StatefulWidget {
  final String collection;
  final String services;

  const AddService(
      {Key key, @required this.collection, @required this.services})
      : super(key: key);

  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  String nameEn, nameAr;
  int pe, pf;

  Future<void> addServices({String nameEn, String nameAr, int pE, int pF}) {
    CollectionReference service = Firestore.instance
        .collection('services_collections/collections/${widget.collection}');
    return service
        .document(nameEn)
        .setData({
          'name_en': nameEn,
          'name_ar': nameAr,
          'costEgy': pE,
          'costForg': pF,
        })
        .then((value) => print("User service"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateServices(
      {String oldName, String nameEn, String nameAr, int pE, int pF}) {
    CollectionReference service = Firestore.instance
        .collection('services_collections/collections/${widget.collection}');
    Firestore.instance
        .collection("services_collections/collections/${widget.collection}")
        .document(oldName)
        .delete();
    return service
        .document(nameEn)
        .setData({
          'name_en': nameEn,
          'name_ar': nameAr,
          'costEgy': pE,
          'costForg': pF,
        })
        .then((value) => print('update'))
        .catchError((error) => print("Failed to add user: $error"));
  }

  deleteData(String name) {
    DocumentReference documentReference = Firestore.instance
        .collection("services_collections/collections/${widget.collection}")
        .document(name);

    documentReference.delete().whenComplete(() {
      return Fluttertoast.showToast(
          msg: '$name ' + translator.translate('deleteSuccess'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red[600].withOpacity(0.9),
          textColor: Colors.white,
          fontSize: 20.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translator.translate('${widget.services}')),
      ),
      body: Container(
          height: size.height,
          width: size.width,
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: size.width,

                  // Add Service Button ..................................................................
                  child: FlatButton(
                    child: Text(
                      translator.translate('add_services'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    padding: EdgeInsets.all(size.height * 0.02),
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey)),
                    splashColor: Colors.grey,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              height: size.height * 0.5,
                              margin: EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                left: 30,
                                right: 30,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    translator.translate('enter_service_data'),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[/]')),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: translator
                                          .translate('serviceNameEng'),
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        nameEn = val;
                                      });
                                    },
                                  ),
                                  TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[/]')),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: translator
                                          .translate('serviceNameArb'),
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        nameAr = val;
                                      });
                                    },
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: translator.translate('costE'),
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        pe = int.parse(val);
                                      });
                                    },
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: translator.translate('costF'),
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        pf = int.parse(val);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: size.width,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(15),
                                      splashColor: Colors.grey,
                                      onPressed: () {
                                        if (nameEn != null &&
                                            nameAr != null &&
                                            pe != null &&
                                            pf != null) {
                                          addServices(
                                              nameEn: nameEn,
                                              nameAr: nameAr,
                                              pE: pe,
                                              pF: pf);
                                          Navigator.of(context).pop();
                                          nameEn = null;
                                          nameAr = null;
                                          pe = null;
                                          pf = null;
                                        } else {
                                          return Fluttertoast.showToast(
                                              msg: translator.translate(
                                                  'completeServiceData'),
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.6),
                                              textColor: Colors.white,
                                              fontSize: 20.0);
                                        }
                                      },
                                      child: Text(
                                        translator.translate('add'),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      color: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: BorderSide(color: Colors.grey)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // List of Services...............................................................
              Expanded(
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection(
                          "services_collections/collections/${widget.collection}")
                      .orderBy('name_en')
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
                                    title: translator.currentLanguage == 'en'
                                        ? Text(
                                            documentSnapshot['name_en'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(fontSize: 16),
                                          )
                                        : Text(
                                            documentSnapshot['name_ar'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(fontSize: 16),
                                          ),
                                    leading: Container(
                                      width: size.width * 0.08,
                                      height: size.height,
                                      color: kPrimaryColor,
                                    ),
                                    trailing: Container(
                                      width: size.width * 0.3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // Edit icon ....................................................................
                                          IconButton(
                                            color: Colors.grey,
                                            icon: CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Colors.grey[600],
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 18,
                                                )),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Container(
                                                      height: size.height * 0.5,
                                                      margin: EdgeInsets.only(
                                                        top: 10,
                                                        bottom: 10,
                                                        left: 30,
                                                        right: 30,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: <Widget>[
                                                          Text(
                                                            translator.translate(
                                                                'update_service_data'),
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          TextFormField(
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .deny(RegExp(
                                                                      '[/]')),
                                                            ],
                                                            /*  enabled: false,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey), */
                                                            initialValue:
                                                                documentSnapshot[
                                                                    'name_en'],
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: translator
                                                                  .translate(
                                                                      'serviceNameEng'),
                                                              labelStyle:
                                                                  TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            onChanged: (val) {
                                                              setState(() {
                                                                nameEn = val;
                                                              });
                                                            },
                                                          ),
                                                          TextFormField(
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .deny(RegExp(
                                                                      '[/]')),
                                                            ],
                                                            initialValue:
                                                                documentSnapshot[
                                                                    'name_ar'],
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: translator
                                                                  .translate(
                                                                      'serviceNameArb'),
                                                              labelStyle:
                                                                  TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            onChanged: (val) {
                                                              setState(() {
                                                                nameAr = val;
                                                              });
                                                            },
                                                          ),
                                                          TextFormField(
                                                            initialValue:
                                                                documentSnapshot[
                                                                        'costEgy']
                                                                    .toString(),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: translator
                                                                  .translate(
                                                                      'costE'),
                                                              labelStyle:
                                                                  TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            onChanged: (val) {
                                                              setState(() {
                                                                pe = int.parse(
                                                                    val);
                                                              });
                                                            },
                                                          ),
                                                          TextFormField(
                                                            initialValue:
                                                                documentSnapshot[
                                                                        'costForg']
                                                                    .toString(),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: translator
                                                                  .translate(
                                                                      'costF'),
                                                              labelStyle:
                                                                  TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            onChanged: (val) {
                                                              setState(() {
                                                                pf = int.parse(
                                                                    val);
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Container(
                                                            width: size.width,
                                                            child: FlatButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(15),
                                                              splashColor:
                                                                  Colors.grey,
                                                              onPressed: () {
                                                                return showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      Dialog(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          130,
                                                                      margin: EdgeInsets.only(
                                                                          top:
                                                                              25,
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              30,
                                                                          right:
                                                                              30),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                              translator.translate('sureUpdateService'),
                                                                              style: TextStyle(
                                                                                fontSize: 18,
                                                                              )),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                FlatButton(
                                                                                  padding: EdgeInsets.all(10),
                                                                                  splashColor: Colors.grey,
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Text(
                                                                                    translator.translate('cancel'),
                                                                                    style: TextStyle(color: Colors.white, fontSize: 17),
                                                                                  ),
                                                                                  color: Colors.red,
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.white)),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                FlatButton(
                                                                                  padding: EdgeInsets.all(10),
                                                                                  splashColor: Colors.grey,
                                                                                  onPressed: () {
                                                                                    updateServices(
                                                                                      oldName: documentSnapshot['name_en'],
                                                                                      nameEn: nameEn != null ? nameEn : documentSnapshot['name_en'],
                                                                                      nameAr: nameAr != null ? nameAr : documentSnapshot['name_ar'],
                                                                                      pE: pe != null ? pe : documentSnapshot['costEgy'],
                                                                                      pF: pf != null ? pf : documentSnapshot['costForg'],
                                                                                    );
                                                                                    Navigator.of(context).pop();
                                                                                    Navigator.of(context).pop();
                                                                                    nameEn = null;
                                                                                    nameAr = null;
                                                                                    pe = null;
                                                                                    pf = null;
                                                                                  },
                                                                                  child: Text(
                                                                                    translator.translate('update'),
                                                                                    style: TextStyle(color: Colors.white, fontSize: 17),
                                                                                  ),
                                                                                  color: kPrimaryColor,
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                translator
                                                                    .translate(
                                                                        'update'),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              color:
                                                                  kPrimaryColor,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          //Delete icon ...........
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Colors.red,
                                            onPressed: () {
                                              // Delete Dialog ..............................
                                              return showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    height: 110,
                                                    margin: EdgeInsets.only(
                                                        top: 25,
                                                        bottom: 10,
                                                        left: 30,
                                                        right: 30),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            translator.translate(
                                                                'sureDeleteService'),
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            )),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              FlatButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                splashColor:
                                                                    Colors.grey,
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                  translator
                                                                      .translate(
                                                                          'cancel'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          17),
                                                                ),
                                                                color:
                                                                    Colors.red,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                splashColor:
                                                                    Colors.grey,
                                                                onPressed: () {
                                                                  deleteData(
                                                                      documentSnapshot[
                                                                          'name_en']);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                  translator
                                                                      .translate(
                                                                          'delete'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          17),
                                                                ),
                                                                color:
                                                                    kPrimaryColor,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                ),
                                              );
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
              )
            ],
          )),
    );
  }
}
