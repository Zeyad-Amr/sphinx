import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/components/roundedButton.dart';

import 'welcome_screen1.dart';

class LangChoise extends StatefulWidget {
  @override
  _LangChoiseState createState() => _LangChoiseState();
}

class _LangChoiseState extends State<LangChoise> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: kPrimaryColor,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    translator.translate('currentLang'),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  RoundedButton(
                    press: () {
                      translator.setNewLanguage(
                        context,
                        newLanguage:
                            translator.currentLanguage == 'ar' ? 'en' : 'ar',
                        remember: true,
                        restart: true,
                      );
                    },
                    text: translator.translate('buttonTitle'),
                    textColor: Colors.white,
                    buttonColor: kPrimaryColor,
                    widthRatioSize: 0.7,
                    paddingRatioSize: 0.02,
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                  ),
                  FlatButton(
                    child: Container(
                      color: kPrimaryColor,
                      child: Text('Next'),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen1(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
