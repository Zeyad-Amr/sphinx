/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sphinx/screens/loading.dart';

class DbHelper {
  static Future<void> addpateint(String userMobile, Map<String, dynamic> data) {
    final CollectionReference user = Firestore.instance.collection('users');
    // Call the user's CollectionReference to add a new user
    return user
        .document(userMobile)
        .setData({
          'name': data['name'],
          'email': data['email'],
          'country': data['country'],
          'age': data['age'],
          'gender': data['gender'],
          'mobile': data['mobile'],
          'userUID': data['userUID'],
          'countryPhoneCode': data['countryPhoneCode'],
          'countryIsoCode': data['countryIsoCode'],
          'info': data['info']
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<void> getPateintData(String userMobile) async {
    await Firestore.instance
        .collection('users')
        .document(userMobile)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.data;
      }
    }).catchError(() => LoadingScreen());
  }
}
 */
