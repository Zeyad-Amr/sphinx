/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class User {}

class Admin extends User {
  final String name, mobile, userUID;
  String info = 'admin';
  final FirebaseUser user;

  Admin({
    @required this.name,
    @required this.mobile,
    this.user,
    this.userUID,
  });
}

class Patient extends User {
  String _name,
      _email,
      _gender,
      _age,
      _country,
      _countryPhoneCode,
      _countryIsoCode,
      _mobile,
      _userUID;
  String _info = 'patient';
  FirebaseUser user;

  Patient(Map<String, dynamic> obj) {
    _name = obj['name'];
    _email = obj['email'];
    _gender = obj['gender'];
    _age = obj['age'];
    _country = obj['country'];
    _countryPhoneCode = obj['countryPhoneCode'];
    _countryIsoCode = obj['countryIsoCode'];
    _mobile = obj['mobile'];
    _userUID = obj['userUID'];
    _info = obj['info'];
  }

  Patient.fromMap(data) {
    _name = data['name'];
    _email = data['email'];
    _gender = data['gender'];
    _age = data['age'];
    _country = data['country'];
    _countryPhoneCode = data['countryPhoneCode'];
    _countryIsoCode = data['countryIsoCode'];
    _mobile = data['mobile'];
    _userUID = data['userUID'];
    _info = data['info'];
  }

  Map<String, dynamic> toMap() => {
        'name': _name,
        'email': _email,
        'gender': _gender,
        'age': _age,
        'country': _country,
        'countryPhoneCode': _countryPhoneCode,
        'countryIsoCode': _countryIsoCode,
        'mobile': _mobile,
        'userUID': _userUID,
        'info': _info
      };
}

class Doctor extends User {
  final String name,
      email,
      gender,
      age,
      country,
      countryPhoneCode,
      countryIsoCode,
      mobile,
      userUID;
  final int priceE, priceF;

  String info = 'doctor';
  final FirebaseUser user;

  final Map<String, Map<String, String>> week;

  Doctor({
    this.week,
    this.user,
    this.userUID,
    @required this.name,
    @required this.mobile,
    @required this.email,
    @required this.gender,
    @required this.age,
    @required this.country,
    @required this.countryPhoneCode,
    @required this.countryIsoCode,
    @required this.priceE,
    @required this.priceF,
  });
}
 */
