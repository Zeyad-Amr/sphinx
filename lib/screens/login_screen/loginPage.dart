import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
  bool isValid = false;
  String phone;

  /* final TextEditingController _phoneNumberController = TextEditingController(); */

  Future<Null> validate(StateSetter updateState) async {
    if (formKey.currentState.validate() == true) {
      updateState(() {
        isValid = true;
      });
    } else if (formKey.currentState.validate() == false) {
      updateState(() {
        isValid = false;
      });
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
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
                                /*  TextFormField(
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
                                  decoration: InputDecoration(
                                    hintText: translator
                                        .translate('loginPage hintText'),
                                    prefix: CountryCodePicker(
                                      onChanged: print,
                                      initialSelection: 'Eg',
                                      favorite: [],
                                      showCountryOnly: false,
                                      showOnlyCountryWhenClosed: false,
                                      alignLeft: false,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.phone_android,
                                      color: kPrimaryColor,
                                    ),
                                    prefixStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(fontWeight: FontWeight.bold),
                                    suffixIcon: isValid
                                        ? Icon(Icons.done)
                                        : Icon(Icons.error, color: Colors.red),
                                  ),
                                  autovalidateMode: AutovalidateMode.always,
                                  autocorrect: false,
                                  maxLengthEnforced: true,
                                  onChanged: (text) {
                                    validate(state);
                                  },
                                ), */

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                      key: formKey,
                                      child: InternationalPhoneNumberInput(
                                        onInputChanged: (PhoneNumber number) {
                                          print(number.phoneNumber);
                                          validate(state);
                                          setState(() {
                                            phone = number.phoneNumber;
                                          });
                                        },
                                        onInputValidated: (bool value) {
                                          setState(() {
                                            isValid = value;
                                          });
                                        },
                                        validator: (val) {
                                          return !formKey.currentState
                                                  .validate()
                                              ? translator
                                                  .translate('loginPage label')
                                              : '';
                                        },
                                        spaceBetweenSelectorAndTextField: 0,
                                        selectorConfig: SelectorConfig(
                                          selectorType: PhoneInputSelectorType
                                              .BOTTOM_SHEET,
                                        ),
                                        inputDecoration: InputDecoration(
                                          hintText: translator
                                              .translate('loginPage hintText'),
                                          prefixStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                          suffixIcon: isValid
                                              ? Icon(Icons.done)
                                              : Icon(Icons.error,
                                                  color: Colors.red),
                                        ),
                                        ignoreBlank: false,
                                        autoValidateMode:
                                            AutovalidateMode.disabled,
                                        selectorTextStyle:
                                            TextStyle(color: Colors.black),
                                        initialValue: number,
                                        textFieldController: controller,
                                        formatInput: false,
                                        keyboardType: TextInputType.number,
                                        inputBorder: UnderlineInputBorder(),
                                        onSaved: (PhoneNumber number) {
                                          print('On Saved: $number');
                                        },
                                      )),
                                )
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
                                    print('lllll  ${number.phoneNumber}');

                                    if (isValid) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OTPScreen(
                                              mobileNumber: phone,
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
