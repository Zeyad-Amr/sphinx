import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';

class AddDoctor extends StatefulWidget {
  @override
  _AddDoctorState createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  File _image;
  String _url;
  String nameEn, nameAr;
  int pe, pf;
  String phone, specialtyEn, specialtyAr;
  int order;

  Future<void> addDoctors({
    String nameEn,
    String nameAr,
    String specialEn,
    String specialAr,
    String phoneN,
    int pE,
    int pF,
    String imgUrl,
    int order,
  }) {
    CollectionReference doctor = Firestore.instance.collection('doctors');
    return doctor
        .document(nameEn)
        .setData({
          'name_en': nameEn,
          'name_ar': nameAr,
          'costEgy': pE,
          'costForg': pF,
          'mobile': phoneN,
          'specialtyEn': specialEn,
          'specialtyAr': specialAr,
          'imgUrl': imgUrl,
          'order': order
        })
        .then((value) => print("User doctor"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateDoctors({
    String oldName,
    String nameEn,
    String nameAr,
    String specialEn,
    String specialAr,
    String phoneN,
    int pE,
    int pF,
    String imgUrl,
    int order,
  }) {
    CollectionReference doctor = Firestore.instance.collection('doctors');

    return doctor
        .document(oldName)
        .updateData({
          'name_en': nameEn,
          'name_ar': nameAr,
          'costEgy': pE,
          'costForg': pF,
          'mobile': phoneN,
          'specialtyEn': specialEn,
          'specialtyAr': specialAr,
          'imgUrl': imgUrl,
          'order': order
        })
        .then((value) => print('update'))
        .catchError((error) => print("Failed to updateeeeee user: $error"));
  }

  deleteData(String name) {
    DocumentReference documentReference =
        Firestore.instance.collection("doctors").document(name);

    documentReference.delete().whenComplete(() {
      return Fluttertoast.showToast(
          msg: '$name ' + translator.translate('deleteSuccess'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 5,
          backgroundColor: Colors.red[600].withOpacity(0.9),
          textColor: Colors.white,
          fontSize: 20.0);
    });
  }

  void pickImage(context, String n) async {
    try {
      final image = await ImagePicker().getImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
      setState(() {
        if (image.path != null) {
          _image = File(image.path);
          print('path : ${image.path}');
        }
      });
      showProgressDialog();
    } catch (ex) {
      print('pick error :: $ex');
      /*  Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(ex.message),
        ),
      ); */
    }
    uploadImage(context, n);
  }

  void uploadImage(context, String n) async {
    try {
      FirebaseStorage storage =
          FirebaseStorage(storageBucket: 'gs://sphinx-a2784.appspot.com/');
      StorageReference ref = storage.ref().child(p.basename('$n.jpg'));
      StorageUploadTask storageUploadTask = ref.putFile(_image);

      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

      /*  Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('success'),
      )); */
      String url = await taskSnapshot.ref.getDownloadURL();
      print('url $url');
      setState(() {
        _url = url;
      });
      dismissProgressDialog();

      /* Fluttertoast.showToast(
          msg: translator.translate('photoSelected'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 5,
          backgroundColor: Colors.black.withOpacity(0.6),
          textColor: Colors.white,
          fontSize: 20.0); */
    } catch (ex) {
      /*  Fluttertoast.showToast(
          msg: ex.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 5,
          backgroundColor: Colors.black.withOpacity(0.6),
          textColor: Colors.white,
          fontSize: 20.0); */
      print('upload error :: $ex');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translator.translate('doctors')),
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

                  // Add Doctor Button ..................................................................
                  child: FlatButton(
                    child: Text(
                      translator.translate('add_doctors'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    padding: EdgeInsets.all(size.height * 0.02),
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey)),
                    splashColor: Colors.grey,
                    onPressed: () {
                      setState(() {
                        nameEn = null;
                        nameAr = null;
                        pe = null;
                        pf = null;
                        phone = null;
                        specialtyAr = null;
                        specialtyEn = null;
                        _url = null;
                        order = null;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              height: size.height * 0.75,
                              margin: EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                left: 30,
                                right: 30,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        translator
                                            .translate('enter_doctor_data'),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp('[/]')),
                                      ],
                                      decoration: InputDecoration(
                                        labelText: translator
                                            .translate('doctorNameEng'),
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
                                            .translate('doctorNameArb'),
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
                                      maxLength: 11,
                                      decoration: InputDecoration(
                                        labelText:
                                            translator.translate('mobile'),
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          phone = '+2$val';
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
                                            .translate('specialtyEng'),
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          specialtyEn = val;
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
                                            .translate('specialtyArb'),
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          specialtyAr = val;
                                        });
                                      },
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText:
                                            translator.translate('costE'),
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
                                        labelText:
                                            translator.translate('costF'),
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
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText:
                                            translator.translate('order'),
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          order = int.parse(val);
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Builder(
                                        builder: (context) => FlatButton.icon(
                                          onPressed: () {
                                            pickImage(context, phone);
                                          },
                                          icon: Icon(Icons.add_a_photo),
                                          label: Text(
                                            translator.translate('choosePhoto'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
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
                                              pf != null &&
                                              phone.length == 13 &&
                                              specialtyAr != null &&
                                              specialtyEn != null &&
                                              _url != null &&
                                              order != null) {
                                            addDoctors(
                                                nameEn: nameEn,
                                                nameAr: nameAr,
                                                pE: pe,
                                                pF: pf,
                                                phoneN: phone,
                                                specialAr: specialtyAr,
                                                specialEn: specialtyEn,
                                                imgUrl: _url,
                                                order: order);
                                            setState(() {
                                              nameEn = null;
                                              nameAr = null;
                                              pe = null;
                                              pf = null;
                                              phone = null;
                                              specialtyAr = null;
                                              specialtyEn = null;
                                              _url = null;
                                              order = null;
                                            });
                                            Navigator.of(context).pop();
                                          } else {
                                            return Fluttertoast.showToast(
                                                msg: translator.translate(
                                                    'completeDoctorData'),
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.TOP,
                                                timeInSecForIos: 5,
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.6),
                                                textColor: Colors.white,
                                                fontSize: 20.0);
                                          }
                                        },
                                        child: Text(
                                          translator.translate('add'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        color: kPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side:
                                                BorderSide(color: Colors.grey)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // List of Doctors...............................................................
              Expanded(
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("doctors")
                      .orderBy('order')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
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
                                              setState(() {
                                                nameEn = null;
                                                nameAr = null;
                                                pe = null;
                                                pf = null;
                                                phone = null;
                                                specialtyAr = null;
                                                specialtyEn = null;
                                                _url = null;
                                                order = null;
                                              });
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
                                                      height:
                                                          size.height * 0.75,
                                                      margin: EdgeInsets.only(
                                                        top: 10,
                                                        bottom: 10,
                                                        left: 30,
                                                        right: 30,
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                translator
                                                                    .translate(
                                                                        'update_doctor_data'),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            TextFormField(
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .deny(RegExp(
                                                                        '[/]')),
                                                              ],
                                                              initialValue:
                                                                  documentSnapshot[
                                                                      'name_en'],
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: translator
                                                                    .translate(
                                                                        'doctorNameEng'),
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
                                                                        'doctorNameArb'),
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
                                                                          'mobile']
                                                                      .toString()
                                                                      .split('')
                                                                      .getRange(
                                                                          2, 13)
                                                                      .join()
                                                                      .toString(),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              maxLength: 11,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: translator
                                                                    .translate(
                                                                        'mobile'),
                                                                labelStyle:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  phone =
                                                                      '+2$val';
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
                                                                      'specialtyEn'],
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: translator
                                                                    .translate(
                                                                        'specialtyEng'),
                                                                labelStyle:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  specialtyEn =
                                                                      val;
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
                                                                      'specialtyAr'],
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: translator
                                                                    .translate(
                                                                        'specialityArb'),
                                                                labelStyle:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  specialtyAr =
                                                                      val;
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
                                                                  pe =
                                                                      int.parse(
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
                                                                  pf =
                                                                      int.parse(
                                                                          val);
                                                                });
                                                              },
                                                            ),
                                                            TextFormField(
                                                              initialValue:
                                                                  documentSnapshot[
                                                                          'order']
                                                                      .toString(),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: translator
                                                                    .translate(
                                                                        'order'),
                                                                labelStyle:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  order =
                                                                      int.parse(
                                                                          val);
                                                                });
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              child: Builder(
                                                                builder:
                                                                    (context) {
                                                                  return FlatButton
                                                                      .icon(
                                                                    onPressed:
                                                                        () {
                                                                      pickImage(
                                                                          context,
                                                                          documentSnapshot['mobile']
                                                                              .toString());
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .add_a_photo),
                                                                    label: Text(
                                                                      translator
                                                                          .translate(
                                                                              'choosePhoto'),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline6,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              width: size.width,
                                                              child: FlatButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
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
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            120,
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
                                                                            Text(translator.translate('sureUpdateDoctor'),
                                                                                style: TextStyle(
                                                                                  fontSize: 18,
                                                                                )),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
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
                                                                                      updateDoctors(
                                                                                        oldName: documentSnapshot['name_en'],
                                                                                        nameEn: nameEn != null ? nameEn : documentSnapshot['name_en'],
                                                                                        nameAr: nameAr != null ? nameAr : documentSnapshot['name_ar'],
                                                                                        pE: pe != null ? pe : documentSnapshot['costEgy'],
                                                                                        pF: pf != null ? pf : documentSnapshot['costForg'],
                                                                                        phoneN: phone != null ? phone : documentSnapshot['mobile'],
                                                                                        specialEn: specialtyEn != null ? specialtyEn : documentSnapshot['specialtyEn'],
                                                                                        specialAr: specialtyAr != null ? specialtyAr : documentSnapshot['specialtyAr'],
                                                                                        imgUrl: _url != null ? _url : documentSnapshot['imgUrl'].toString(),
                                                                                        order: order != null ? order : documentSnapshot['order'],
                                                                                      );

                                                                                      nameEn = null;
                                                                                      nameAr = null;
                                                                                      pe = null;
                                                                                      pf = null;
                                                                                      phone = null;
                                                                                      specialtyAr = null;
                                                                                      specialtyEn = null;
                                                                                      _url = null;
                                                                                      order = null;

                                                                                      Navigator.of(context).pop();
                                                                                      Navigator.of(context).pop();
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
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .grey)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                                                'sureDeleteDoctor'),
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
