import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/components/roundedButton.dart';

import 'go_login.dart';

class WelcomeScreen3 extends StatelessWidget {
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
              top: size.height * -0.15, //size.height *  -0.03
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
                  'assets/icons/bo3.png',
                  height: size.height * 0.3,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  translator.translate('welcome3-1'),
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .apply(color: Colors.white),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  translator.translate('welcome3-2'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .apply(color: Colors.white),
                ),
                SizedBox(
                  height: size.height * 0.27,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundedButton(
                      press: () {
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
                            builder: (context) => GoLogin(),
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
