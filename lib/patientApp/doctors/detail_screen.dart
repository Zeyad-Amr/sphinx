import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/providers/UserDataProvider.dart';

class DetailScreen extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final int cost;
  final String docMobile;

  DetailScreen(
      {Key key,
      @required this.name,
      @required this.description,
      @required this.imageUrl,
      @required this.cost,
      @required this.docMobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<User>(
          builder: (context, currentUser, child) => Container(
            width: double.infinity,
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/detail_illustration.png'),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: BackButton(
                            color: kWhiteColor,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Text(translator.translate('bookNow').toUpperCase(),
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 30, color: kWhiteColor)),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 80,
                                    child: imageUrl != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              imageUrl,
                                            ),
                                            radius: 40,
                                          )
                                        : CircleAvatar(
                                            backgroundColor: kPrimaryColor,
                                            radius: 40,
                                          ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      description,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: kPrimaryColor.withOpacity(0.7),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '$cost ' + translator.translate('L.E'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    color: kPrimaryColor,
                                    textColor: Colors.white,
                                    child: Text(
                                      translator.translate('book'),
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    onPressed: () {
                                      Firestore.instance
                                          .collection('requests')
                                          .document(DateTime.now().toString())
                                          .setData({
                                        'name': currentUser.name,
                                        'phone': currentUser.mobile,
                                        'age': currentUser.age,
                                        'gender': currentUser.gender,
                                        'country': currentUser.country,
                                        'DoctorPhone': docMobile,
                                        'DoctorName': name,
                                        'state': 0,
                                        'date': DateTime.now().toString(),
                                        'imgUrl':imageUrl
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: size.height * -0.12, //size.height *  -0.03
                        right: size.width * -0.22,
                        child: Image.asset('assets/images/04.png'),
                        width: size.width * 0.7,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
