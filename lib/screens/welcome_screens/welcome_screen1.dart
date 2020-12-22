import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/components/roundedButton.dart';
import 'go_login.dart';
import 'welcome_screen2.dart';

class WelcomeScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: size.height * -0.2, //size.height *  -0.03
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
                    Container(
                      width: size.width * 0.2,
                      child: ClipRRect(
                        child: FlatButton(
                          padding: EdgeInsets.all(size.height * 0.01),
                          onPressed: () {
                            translator.setNewLanguage(
                              context,
                              newLanguage: translator.currentLanguage == 'ar'
                                  ? 'en'
                                  : 'ar',
                              remember: true,
                              restart: true,
                            );
                          },
                          child: Text(
                            translator.translate('buttonTitle'),
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(29),
                              side: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/icons/bo1.png',
                  height: size.height * 0.3,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Text(
                  translator.translate('welcome1-1'),
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .apply(color: Colors.white),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  translator.translate('welcome1-2'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .apply(color: Colors.white),
                ),
                SizedBox(
                  height: size.height * 0.23,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundedButton(
                      press: () {
                        print('Go L');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GoLogin(),
                          ),
                        );
                      },
                      text: translator.translate('skip'),
                      buttonColor: Colors.white,
                      textColor: kPrimaryColor,
                      widthRatioSize: 0.3,
                      paddingRatioSize: 0.025,
                    ),
                    RoundedButton(
                      press: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WelcomeScreen2(),
                          ),
                        );
                      },
                      text: translator.translate('next'),
                      buttonColor: Colors.white,
                      textColor: kPrimaryColor,
                      widthRatioSize: 0.3,
                      paddingRatioSize: 0.025,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
