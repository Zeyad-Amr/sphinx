import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';

import 'requests/requestsList.dart';

class HomeWidgetDoctor extends StatefulWidget {
  const HomeWidgetDoctor({
    Key key,
  }) : super(key: key);

  @override
  _HomeWidgetDoctorState createState() => _HomeWidgetDoctorState();
}

class _HomeWidgetDoctorState extends State<HomeWidgetDoctor> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          Container(
            height: size.width * 0.6,
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image(
                image: AssetImage('assets/images/homeDoctor.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Doctor Destination ............................................................................
          Padding(
            padding:
                const EdgeInsets.only(top: 30.0, left: 5, right: 5, bottom: 10),
            child: Column(
              children: [
                FlatButton(
                  splashColor: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RequestsList(),
                      ),
                    );
                  },
                  child: Container(
                    height: size.width * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.help_outline,
                              color: kPrimaryColor,
                              size: size.width * 0.2,
                            )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 8),
                              child: Text(translator.translate('requests'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ),
                            Text(
                              translator.translate('appReq'),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
