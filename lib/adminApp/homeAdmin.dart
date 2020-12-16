import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sphinx/components/constants.dart';
import 'services/servicesList.dart';
import 'doctors/addDoctor.dart';

class HomeWidgetAdmin extends StatefulWidget {
  const HomeWidgetAdmin({
    Key key,
  }) : super(key: key);

  @override
  _HomeWidgetAdminState createState() => _HomeWidgetAdminState();
}

class _HomeWidgetAdminState extends State<HomeWidgetAdmin> {
  Items item1 = new Items(
    title: translator.translate('doctors'),
    img: "assets/icons/doctor.png",
  );

  Items item2 = new Items(
    title: translator.translate('services'),
    subtitle: "Bocali, Apple",
    img: "assets/icons/services.png",
  );
  /* Items item3 = new Items(
    title: "Locations",
    img: "assets/icons/logo.png",
  );
  Items item4 = new Items(
    title: "Activity",
    img: "assets/icons/logo.png",
  );
 */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Items> myList = [item1, item2 /* , item3, item4 */];

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
                  padding: EdgeInsets.only(left: 16, right: 16),
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  children: myList.map((data) {
                    return GestureDetector(
                      onTap: () {
                        if (data.title == translator.translate('doctors')) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddDoctor(),
                            ),
                          );
                        } else if (data.title ==
                            translator.translate('services')) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ServicesList(),
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
                            SizedBox(
                              height: 14,
                            ),
                            Text(
                              data.title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
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
