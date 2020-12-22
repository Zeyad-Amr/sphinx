import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sphinx/components/constants.dart';
import 'package:sphinx/providers/UserDataProvider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailScreen extends StatefulWidget {
  final String docNameEn;
  final String docNameAr;
  final String docMobile;
  final String descriptionEn;
  final String descriptionAr;
  final String imageUrl;
  final int cost;

  DetailScreen(
      {Key key,
      @required this.descriptionEn,
      @required this.descriptionAr,
      @required this.imageUrl,
      @required this.cost,
      @required this.docMobile,
      @required this.docNameEn,
      @required this.docNameAr})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  uniqueId() {
    String uniqueId =
        UniqueKey().toString().split('').getRange(2, 7).join().toString() +
            UniqueKey().toString().split('').getRange(2, 7).join().toString() +
            UniqueKey().toString().split('').getRange(2, 7).join().toString();
    return uniqueId;
  }

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
                                    child: widget.imageUrl != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              widget.imageUrl,
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
                                    translator.currentLanguage == 'en'
                                        ? Text(
                                            widget.docNameEn,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Colors.black,
                                            ),
                                          )
                                        : Text(
                                            widget.docNameAr,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Colors.black,
                                            ),
                                          ),
                                    translator.currentLanguage == 'en'
                                        ? Text(
                                            widget.descriptionEn,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: kPrimaryColor
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            widget.descriptionAr,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: kPrimaryColor
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.bold),
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${widget.cost} ' +
                                          translator.translate('L.E'),
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
                                      String id = uniqueId();
                                      print(id);
                                      /* 
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => WebView(
                                            onPageStarted: (input) {},
                                            onPageFinished: (output) {
                                              print(
                                                  'Paaaayymmeeeeeeeeeeeeeeeeeeeeeeent');
                                              print(output);
                                              if (output
                                                  .contains('NBESuccess.php')) { */
                                      Firestore.instance
                                          .collection('requests')
                                          .document(DateTime.now().toString())
                                          .setData({
                                        'Id': id,
                                        'name': currentUser.name,
                                        'phone': currentUser.mobile,
                                        'age': currentUser.age,
                                        'gender': currentUser.gender,
                                        'country': currentUser.country,
                                        'DoctorPhone': widget.docMobile,
                                        'DoctorNameEn': widget.docNameEn,
                                        'DoctorNameAr': widget.docNameAr,
                                        'specialtyAr': widget.descriptionAr,
                                        'specialtyEn': widget.descriptionEn,
                                        'cost': widget.cost,
                                        'state': 0,
                                        'date': DateTime.now().toString(),
                                        'imgUrl': widget.imageUrl
                                      });
                                      Navigator.of(context).pop();
                                      /*  Fluttertoast.showToast(
                                                    msg: translator.translate(
                                                        'successPay'),
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIos: 5,
                                                    backgroundColor: Colors
                                                        .green
                                                        .withOpacity(0.6),
                                                    textColor: Colors.white,
                                                    fontSize: 20.0);
                                              } else if (output
                                                  .contains('NBEFailed.php')) {
                                                print(
                                                    'OUTPUT IS ................. $output');
                                                Navigator.of(context).pop();
                                                Fluttertoast.showToast(
                                                    msg: translator
                                                        .translate('failedPay'),
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIos: 5,
                                                    backgroundColor: Colors.red
                                                        .withOpacity(0.6),
                                                    textColor: Colors.white,
                                                    fontSize: 20.0);
                                              } else if (output
                                                  .contains('NBECancel.php')) {
                                                print(
                                                    'OUTPUT IS ................. $output');
                                                Navigator.of(context).pop();
                                                Fluttertoast.showToast(
                                                    msg: translator.translate(
                                                        'canceledPay'),
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIos: 5,
                                                    backgroundColor: Colors.red
                                                        .withOpacity(0.6),
                                                    textColor: Colors.white,
                                                    fontSize: 20.0);
                                              }
                                            },
                                            initialUrl:
                                                "https://onlineconsultation.sphinxkc.com/NBEPayment.php?s_name=${currentUser.name}&s_price=${widget.cost}&OID=$id",
                                            javascriptMode:
                                                JavascriptMode.unrestricted,
                                          ),
                                        ),
                                      ); */
                                      print(id);
                                    },
                                  ),
                                ),
                              ),
                              /*   RaisedButton(
                                onPressed: () {
                                  print(uniqueId);
                                },
                                child: Text('click'),
                              ), */
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
