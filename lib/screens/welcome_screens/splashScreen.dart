import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sphinx/components/fadeAnimation.dart';
import 'package:sphinx/services/app.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => App(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.white),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.3,
                      ),
                      FadeAnimation(
                        0.5,
                        Image(
                          image: AssetImage('assets/icons/logo.png'),
                          width: size.width * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.3,
              ),
              Expanded(
                  flex: 1,
                  child: FadeAnimation(
                    1,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Powered by Dev Solution',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                        Text(
                          'Copyright © Sphinx Kcc',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          'All Rights Reserved',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
