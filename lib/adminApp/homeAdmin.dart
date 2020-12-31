import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/adminApp/fawryList.dart';
import 'package:sphinx/adminApp/notification/addNotification.dart';
import 'package:sphinx/adminApp/services/servicesList.dart';
import 'package:sphinx/components/constants.dart';
import 'bookedServicesList.dart';
import 'appointmentsList.dart';
import 'requestsList.dart';
import 'usersList.dart';

class HomeWidgetAdmin extends StatefulWidget {
  const HomeWidgetAdmin({
    Key key,
  }) : super(key: key);

  @override
  _HomeWidgetAdminState createState() => _HomeWidgetAdminState();
}

class _HomeWidgetAdminState extends State<HomeWidgetAdmin> {
  String notifTitle;

  String notifMessage;
  Items item1 = new Items(
    title: translator.translate('users'),
    img: "assets/icons/user.png",
  );

  Items item2 = new Items(
    title: translator.translate('doctors') +
        ' & ' +
        translator.translate('services'),
    img: "assets/icons/ds.png",
  );
  Items item3 = new Items(
    title: translator.translate('requests'),
    img: "assets/icons/request.png",
  );
  Items item4 = new Items(
    title: translator.translate('appointments'),
    img: "assets/icons/appointment.png",
  );
  Items item5 = new Items(
    title: translator.translate('bookedSerives'),
    img: "assets/icons/bookedServices.png",
  );
  Items item6 = new Items(
    title: translator.translate('fawryReq'),
    img: "assets/icons/fawryw.png",
  );

  Items item7 = new Items(
    title: translator.translate('sendNotification'),
    img: "assets/icons/sendNotif.png",
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Items> myList = [item1, item2, item3, item4, item5, item6, item7];

    return Container(
      height: size.height,
      width: size.width,
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: [
            /*  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                  child: Text(
                    'Administration Account',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ), */
            Flexible(
              child: GridView.count(
                  childAspectRatio: 1.0,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: myList.map((data) {
                    return GestureDetector(
                      onTap: () {
                        if (data.title == translator.translate('fawryReq')) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FawryList(),
                            ),
                          );
                        } else if (data.title ==
                            translator.translate('doctors') +
                                ' & ' +
                                translator.translate('services')) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ServicesListAdmin(),
                            ),
                          );
                        } else if (data.title ==
                            translator.translate('bookedSerives')) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BookedServices(),
                            ),
                          );
                        } else if (data.title ==
                            translator.translate('appointments')) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AppointmentsList(),
                            ),
                          );
                        } else if (data.title ==
                            translator.translate('requests')) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RequestsListAdmin(),
                            ),
                          );
                        } else if (data.title ==
                            translator.translate('users')) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UsersList(),
                            ),
                          );
                        } else if (data.title ==
                            translator.translate('sendNotification')) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddNotification(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              data.img,
                              width: 80,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14.0, horizontal: 10),
                              child: Text(
                                data.title,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ],
        ),
      ),
    );
  }
}

class Items {
  final String title;
  final String subtitle;

  final String img;

  Items({this.title, this.subtitle, this.img});
}
