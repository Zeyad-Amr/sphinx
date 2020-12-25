import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/components/roundedButton.dart';
import 'verificationScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  bool isValid = false;

  Future<Null> validate(StateSetter updateState) async {
    print("in validate : ${_phoneNumberController.text.length}");
    if (_phoneNumberController.text.length == 11) {
      updateState(() {
        isValid = true;
      });
    } else if (_phoneNumberController.text.length != 11) {
      updateState(() {
        isValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              height: size.height,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: size.width * -0.9, //size.height *  -0.03
                    child: Image.asset('assets/images/01.png'),
                    width: size.width,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          BackButton(
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/icons/bo5.png',
                        height: size.width * 0.3,
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        width: size.width * 0.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  translator.translate('loginPage 1'),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  translator.translate('loginPage 2'),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                TextFormField(
                                  autofocus: true,
                                  controller: _phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    return !isValid
                                        ? translator
                                            .translate('loginPage label')
                                        : null;
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  textAlign: translator.currentLanguage == 'en'
                                      ? TextAlign.start
                                      : TextAlign.end,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  decoration: translator.currentLanguage == 'en'
                                      ? InputDecoration(
                                          hintText: translator
                                              .translate('loginPage hintText'),
                                          prefixText: '+2   ',
                                          prefixIcon: Icon(
                                            Icons.phone_android,
                                            color: kPrimaryColor,
                                          ),
                                          prefixStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                          suffixIcon: isValid
                                              ? Icon(Icons.done)
                                              : Icon(Icons.error,
                                                  color: Colors.red),
                                        )
                                      : InputDecoration(
                                          hintText: translator
                                              .translate('loginPage hintText'),
                                          suffixText: '   +2',
                                          suffixIcon: Icon(
                                            Icons.phone_android,
                                            color: kPrimaryColor,
                                          ),
                                          suffixStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                          prefixIcon: isValid
                                              ? Icon(Icons.done)
                                              : Icon(Icons.error,
                                                  color: Colors.red),
                                        ),
                                  autovalidateMode: AutovalidateMode.always,
                                  autocorrect: false,
                                  maxLengthEnforced: true,
                                  onChanged: (text) {
                                    validate(state);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RoundedButton(
                                  press: () {
                                    if (isValid) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OTPScreen(
                                              mobileNumber:
                                                  _phoneNumberController.text,
                                            ),
                                          ));
                                    } else {
                                      validate(state);
                                    }
                                  },
                                  text: translator.translate('verify'),
                                  buttonColor: kPrimaryColor,
                                  textColor: Colors.white,
                                  widthRatioSize: 0.7,
                                  fontS: size.height * 0.02,
                                  paddingRatioSize: 0.02,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: size.height * -0.15, //size.height *  -0.03
                    right: size.width * -0.2,
                    child: Image.asset('assets/images/04.png'),
                    width: size.width * 0.6,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
