import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/components/roundedButton.dart';
import 'package:sphinx/screens/login_screen/loginPage.dart';

class GoLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: size.width * -0.5, //size.height *  -0.03
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
                    BackButton(
                      color: Colors.white,
                    ),
                  ],
                ),
                Image.asset(
                  'assets/icons/bo4.png',
                  height: size.height * 0.28,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),

                /* Text(
            'nearby you',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ), */
                SizedBox(
                  height: size.height * 0.15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundedButton(
                      press: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      ),
                      text: translator.translate('loginButton'),
                      buttonColor: kPrimaryColor,
                      textColor: Colors.white,
                      widthRatioSize: 0.8,
                      fontS: size.height * 0.02,
                      paddingRatioSize: 0.025,
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  translator.translate('agreeToTerms'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .apply(color: Colors.black),
                ),
              ],
            ),
            Positioned(
              bottom: size.height * -0.2, //size.height *  -0.03
              right: size.width * -0.2,
              child: Image.asset('assets/images/04.png'),
              width: size.width * 0.6,
            ),
          ],
        ),
      ),
    );
  }
}
