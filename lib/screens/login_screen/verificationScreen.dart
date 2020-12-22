import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/components/otp_input.dart';
import 'package:sphinx/components/roundedButton.dart';
import 'package:sphinx/providers/UserDataProvider.dart';
import 'package:sphinx/services/app.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  OTPScreen({
    Key key,
    @required this.mobileNumber,
  })  : assert(mobileNumber != null),
        super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Control the input text field.
  TextEditingController _pinEditingController = TextEditingController();

  /// Decorate the outside of the Pin.
  PinDecoration _pinDecoration =
      UnderlineDecoration(enteredColor: Colors.black, hintText: '      ');

  bool isCodeSent = false;
  String _verificationId;

  @override
  void initState() {
    super.initState();
    _onVerifyCode();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("isValid - $isCodeSent");
    print("mobiel ${widget.mobileNumber}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListenableProvider(
        create: (context) => User(),
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: size.height * -0.5, //size.height *  -0.03
                child: Image.asset('assets/images/03.png'),
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
                      CloseButton(
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/icons/bo5.png',
                    height: size.height * 0.15,
                  ),
                  SizedBox(
                    height: size.height * 0.12,
                  ),
                  Text(
                    translator.translate('enterCode'),
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.bold, color: kPrimaryColor),
                  ),
                  Text(
                    '******',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        fontWeight: FontWeight.bold, color: kPrimaryLightColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translator.translate('ver1'),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        ' ${widget.mobileNumber}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                  Text(
                    translator.translate('ver2'),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //OTP Container
                            Container(
                              width: size.width * 0.7, //0.12
                              height: size.height * 0.06,

                              child: Center(
                                child: PinInputTextField(
                                  pinLength: 6,
                                  decoration: _pinDecoration,
                                  controller: _pinEditingController,
                                  autoFocus: true,
                                  textInputAction: TextInputAction.done,
                                  onSubmit: (pin) {
                                    if (pin.length == 6) {
                                      _onFormSubmitted();
                                    } else {
                                      showToast("Invalid OTP", Colors.red);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RoundedButton(
                            press: () {
                              if (_pinEditingController.text.length == 6) {
                                _onFormSubmitted();
                              } else {
                                showToast("Invalid OTP", Colors.red);
                              }
                            },
                            text: translator.translate('login'),
                            buttonColor: kPrimaryColor,
                            textColor: Colors.white,
                            widthRatioSize: 0.8,
                            fontS: size.height * 0.02,
                            paddingRatioSize: 0.02,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Positioned(
                bottom: size.height * -0.15, //size.height *  -0.03
                right: size.width * -0.25,
                child: Image.asset('assets/images/04.png'),
                width: size.width * 0.65,
              ),
            ],
          ),
        ),
      ),
    );
  }

// Show Toast ......................................................
  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 5,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

// Phone Number Verification Method ...............................................
  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });

    // Phone Verification Completed automatically........................
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      User userModel;
      userModel = Provider.of<User>(context, listen: false);
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((AuthResult value) {
        if (value.user != null) {
          userModel.user = value.user;
          userModel.mobile = widget.mobileNumber;
          // Handle loogged in state

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => App(),
              ),
              (Route<dynamic> route) => false);
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      }).catchError((error) {
        showToast("Try again in sometime", Colors.red);
      });
    };

    // Phone Verification Failed ........................
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      showToast(authException.message, kPrimaryLightColor);
      setState(() {
        isCodeSent = false;
      });
    };
    // Phone Code Sent ........................
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    // Phone Time Out ........................
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

// Function to verify  ........................
    //  Change country code.................

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+2${widget.mobileNumber}",
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

// Phone Verification Completed on Manually Submission........................
  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);

    User userModel;
    userModel = Provider.of<User>(context, listen: false);
    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((AuthResult value) {
      if (value.user != null) {
        userModel.user = value.user;
        userModel.mobile = widget.mobileNumber;
        // Handle loogged in state
        print(value.user.phoneNumber);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => App(),
            ),
            (Route<dynamic> route) => false);
      } else {
        showToast("Error validating OTP, try again", Colors.red);
      }
    }).catchError((error) {
      showToast("Something went wrong", Colors.red);
    });
  }
}
