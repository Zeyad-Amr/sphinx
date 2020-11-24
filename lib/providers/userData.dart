/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sphinx/helper/helper.dart';
import 'package:sphinx/models/model.dart';

class UserData with ChangeNotifier {
  User _user;
  User get user {
    return _user;
  }

  void addPatientUser(
      FirebaseUser currentUser, String userMobile, Map<String, dynamic> data) {
    _user = Patient(data);
    notifyListeners();
    DbHelper.addpateint(userMobile, {
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
    });
  }

  Future<void> getPatientUserData(String userMobile) {
    final userData = DbHelper.getPateintData(userMobile);
    toMap()
    notifyListeners();
  }
}
 */
