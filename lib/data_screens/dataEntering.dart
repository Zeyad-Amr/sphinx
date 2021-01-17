import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/patientApp/accountPage.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/providers/UserDataProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sphinx/services/app.dart';

class DataEntering extends StatefulWidget {
  final FirebaseUser user;

  const DataEntering({
    Key key,
    @required this.user,
  })  : assert(user != null),
        super(key: key);
  @override
  _DataEnteringState createState() => _DataEnteringState();
}

class _DataEnteringState extends State<DataEntering> {
  final fbm = FirebaseMessaging();
  String ageValue;
  String genderValue;
  String nameValue;
  String emailValue;
  String countryValue;

  bool selectMode = false;

  bool isValid = false;
  bool emailValid = false;
  bool nameValid = false;
  bool ageValid = false;
  bool genderValid = false;
  bool countryValid = false;

  Future<Null> validate(StateSetter updateState) async {
    if (nameValue.length > 6) {
      updateState(() {
        nameValid = true;
      });
    } else if (nameValue.length <= 6) {
      updateState(() {
        nameValid = false;
      });
    }

    updateState(() {
      emailValid = EmailValidator.validate(emailValue);
    });

    if (ageValue != null) {
      updateState(() {
        ageValid = true;
      });
    } else {
      updateState(() {
        ageValid = false;
      });
    }
    if (genderValue != null) {
      updateState(() {
        genderValid = true;
      });
    } else {
      updateState(() {
        genderValid = false;
      });
    }
    if (countryValue != null) {
      updateState(() {
        countryValid = true;
      });
    } else {
      updateState(() {
        countryValid = false;
      });
    }
    if (nameValid && emailValid && ageValid && genderValid && countryValid) {
      updateState(() {
        isValid = true;
      });
    } else {
      updateState(() {
        isValid = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            translator.translate('sphinx'),
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => App(),
                ));
              },
            )
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: size.height,
            width: size.width,
            color: Colors.grey[200],
            child: Consumer<User>(
              builder: (context, currentUser, child) {
                return ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 40, bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 25.0, right: 25.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        translator.translate('enterdata'),
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          // Name ................................................................
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        translator.translate('fullname'),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    decoration: translator.currentLanguage ==
                                            'en'
                                        ? const InputDecoration(
                                            hintText: "Enter Your Full Name",
                                          )
                                        : const InputDecoration(
                                            hintText: "ادخل إسمك كامل",
                                          ),
                                    keyboardType: TextInputType.name,
                                    autovalidateMode: AutovalidateMode.always,
                                    validator: (value) {
                                      return !nameValid
                                          ? translator.translate('name label')
                                          : null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        nameValue = value;
                                        currentUser.name = value;
                                      });
                                      validate(state);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Email .........................................................................
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      translator.translate('email'),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    decoration: translator.currentLanguage ==
                                            'en'
                                        ? const InputDecoration(
                                            hintText: "Enter Your Email",
                                          )
                                        : const InputDecoration(
                                            hintText: "ادخل بريدك الإلكتروني",
                                          ),
                                    keyboardType: TextInputType.emailAddress,
                                    autovalidateMode: AutovalidateMode.always,
                                    validator: (value) {
                                      return !emailValid
                                          ? translator.translate('email label')
                                          : null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        emailValue = value;
                                        currentUser.email = value;
                                      });
                                      validate(state);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Mobile Number ...............................................
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        bottom: 8.0,
                                        top: 25),
                                    child: new Row(
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              translator.translate('mobile'),
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      children: <Widget>[
                                        Text(
                                          widget.user.phoneNumber,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Country .................................................................
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: new Row(
                                          children: <Widget>[
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                new Text(
                                                  translator
                                                      .translate('country'),
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        children: <Widget>[
                                          Container(
                                            width: size.width * 0.75,
                                            height: size.height * 0.05,
                                            child: Row(
                                              children: <Widget>[
                                                //Select Mode false
                                                selectMode
                                                    ? SizedBox(
                                                        width: 1,
                                                      )
                                                    : CountryCodePicker(
                                                        builder: (context) =>
                                                            Row(
                                                          children: [
                                                            Text(
                                                                'Select your Country'),
                                                            Icon(Icons
                                                                .keyboard_arrow_down)
                                                          ],
                                                        ),
                                                        hideMainText: true,
                                                        showFlagMain: false,
                                                        onChanged:
                                                            (selectedCountry) {
                                                          setState(() {
                                                            selectMode = true;
                                                            countryValid = true;
                                                          });
                                                          setState(() {
                                                            countryValue =
                                                                selectedCountry
                                                                    .name;
                                                          });
                                                          currentUser.country =
                                                              selectedCountry
                                                                  .name;
                                                          currentUser
                                                                  .countryCode =
                                                              selectedCountry
                                                                  .code;
                                                          print(selectedCountry
                                                              .name);
                                                          print(selectedCountry
                                                              .code);
                                                          print(selectedCountry
                                                              .dialCode);
                                                          print(selectedCountry
                                                              .flagUri);
                                                        },
                                                        initialSelection:
                                                            currentUser
                                                                .countryCode,
                                                        showCountryOnly: true,
                                                        showOnlyCountryWhenClosed:
                                                            true,
                                                      ),
                                                CountryCodePicker(
                                                  hideMainText: !selectMode,
                                                  showFlagMain: selectMode,
                                                  onChanged: (selectedCountry) {
                                                    setState(() {
                                                      selectMode = true;
                                                      countryValid = true;
                                                    });
                                                    setState(() {
                                                      countryValue =
                                                          selectedCountry.name;
                                                    });
                                                    currentUser.country =
                                                        selectedCountry.name;
                                                    currentUser.countryCode =
                                                        selectedCountry.code;
                                                    print(selectedCountry.name);
                                                    print(selectedCountry.code);
                                                    print(selectedCountry
                                                        .dialCode);
                                                    print(selectedCountry
                                                        .flagUri);
                                                  },
                                                  initialSelection:
                                                      currentUser.countryCode,
                                                  showCountryOnly: true,
                                                  showOnlyCountryWhenClosed:
                                                      true,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Age .............................................
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(top: 25.0),
                                      child: new Row(
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                translator.translate('age'),
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child: new Row(
                                      children: <Widget>[
                                        DropdownButton<String>(
                                          hint: Text(translator
                                              .translate('chooseage')),
                                          value: currentUser.age,
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                          ),
                                          iconSize: 24,
                                          elevation: 16,
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.transparent,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              ageValue = newValue;
                                              currentUser.age = newValue;
                                            });
                                            validate(state);
                                          },
                                          items: <String>[
                                            '  -18',
                                            '18-24',
                                            '25-34',
                                            '35-44',
                                            '45-54',
                                            '55-64',
                                            '65-  ',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Gender .................................................................
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(top: 25.0),
                                      child: new Row(
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                translator.translate('gender'),
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child: new Row(
                                      children: <Widget>[
                                        DropdownButton<String>(
                                          hint: Text(translator
                                              .translate('choosegender')),
                                          value: currentUser.gender == 'Male'
                                              ? translator.translate('male')
                                              : currentUser.gender == 'Female'
                                                  ? translator
                                                      .translate('female')
                                                  : currentUser.gender,
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                          ),
                                          iconSize: 24,
                                          elevation: 16,
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.transparent,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              genderValue = newValue;
                                              currentUser.gender = newValue;
                                            });
                                            validate(state);
                                          },
                                          items: <String>[
                                            translator.translate('male'),
                                            translator.translate('female'),
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: size.width * 0.7,
                            child: FlatButton(
                              splashColor: Colors.grey,
                              padding: EdgeInsets.all(size.height * 0.02),
                              onPressed: () {
                                currentUser.mobile = widget.user.phoneNumber;
                                if (nameValid &&
                                    emailValid &&
                                    ageValid &&
                                    genderValid &&
                                    countryValue != null) {
                                  currentUser.addUser(widget.user);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AccountPage(
                                          user: widget.user,
                                        ),
                                      ),
                                      (Route<dynamic> route) => false);
                                } else {
                                  showToastData(
                                      'Please , Enter all your data correctly',
                                      Colors.black.withOpacity(0.6));
                                }
                                print('valid $isValid');
                                print('1 $nameValid');
                                print('2 $emailValid');
                                print('3 $ageValid');
                                print('4 $genderValid');
                                print('5 $countryValid');
                                print('countryValue $countryValue');
                                print('name ${currentUser.name}');
                                print('email ${currentUser.email}');
                                print('age ${currentUser.age}');
                                print('gender ${currentUser.gender}');
                                print('country ${currentUser.country}');
                                print('mobile ${currentUser.mobile}');
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: Colors.grey)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }
}

void showToastData(String messege, Color color) {
  Fluttertoast.showToast(
      msg: messege,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 20.0);
}
