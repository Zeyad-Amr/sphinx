import 'package:flutter/material.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/components/fadeAnimation.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
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
                        height: size.height * 0.2,
                      ),
                      FadeAnimation(
                          0.5,
                          CircularProgressIndicator(
                            backgroundColor: kPrimaryColor,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('Loading'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.3,
              ),
            ],
          )
        ],
      ),
    );
  }
}
