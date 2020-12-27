import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String _name,
      _mobile,
      _email,
      _gender,
      _age,
      _country,
      _userUID,
      _info;
     
  FirebaseUser _user;
  final fbm = FirebaseMessaging();
  String _countryCode;

// Token User Settter and Getter .............................

// Firebase User Settter and Getter .............................
  set user(FirebaseUser value) {
    this._user = value;
    this._userUID = value.uid;
    notifyListeners();
  }

  get user {
    return _user;
  }

  // Name Settter and Getter ................................
  set name(String value) {
    this._name = value;
    notifyListeners();
  }

  get name {
    return _name;
  }

  // Mobile Settter and Getter .........................
  set mobile(String value) {
    _mobile = value;
    notifyListeners();
  }

  get mobile {
    return _mobile;
  }

  // Email Settter and Getter ..............................
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  get email {
    return _email;
  }

  // Gender Settter and Getter ..............................
  set gender(String value) {
    _gender = value;
    notifyListeners();
  }

  get gender {
    return _gender;
  }

  // age Settter and Getter ................................
  set age(String value) {
    _age = value;
    notifyListeners();
  }

  get age {
    return _age;
  }

  // country Settter and Getter .................................
  set country(String value) {
    _country = value;
    notifyListeners();
  }

  get country {
    return _country;
  }
  // countryCode  Settter and Getter .................................

  set countryCode(String value) {
    this._countryCode = value;

    notifyListeners();
  }

  get countryCode {
    return _countryCode;
  }

  // userTyoe Settter and Getter ................................
  set info(String value) {
    _info = value;
    notifyListeners();
  }

  get info {
    return _info;
  }

  // UserUID Settter and Getter ...................................
  set userUID(String value) {
    this._userUID = _user.uid;
    notifyListeners();
  }

  get userUID {
    return _userUID;
  }

  // Add User
  Future<void> addUser(FirebaseUser currentUser) async {
    CollectionReference user = Firestore.instance.collection('users');

    String deviceToken = await fbm.getToken();

    // Call the user's CollectionReference to add a new user
    return user
        .document(this._mobile)
        .setData({
          'name': this._name,
          'email': this._email,
          'country': this._country,
          'age': this._age,
          'gender': this._gender,
          'mobile': this._mobile,
          'userUID': currentUser.uid,
          'countryCode': this._countryCode,
          'info': 'patient',
          'token': deviceToken
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUserData(FirebaseUser currentUser) async {
    CollectionReference user = Firestore.instance.collection('users');

    String deviceToken = await fbm.getToken();
    // Call the user's CollectionReference to add a new user
    return user
        .document(this._mobile)
        .updateData({
          'name': this._name,
          'email': this._email,
          'country': this._country,
          'age': this._age,
          'gender': this._gender,
          'countryCode': this._countryCode,
          'token': deviceToken
        })
        .then((value) => print("User Data Updayed"))
        .catchError((error) => print("Failed to update user data: $error"));
  }

  Future<void> getUserData(FirebaseUser userr) async {
    await Firestore.instance
        .collection('users')
        .document(userr.phoneNumber)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('exist doc');
        _name = documentSnapshot.data['name'];
        _email = documentSnapshot.data['email'];
        _gender = documentSnapshot.data['gender'];
        _age = documentSnapshot.data['age'];
        _country = documentSnapshot.data['country'];
        _mobile = documentSnapshot.data['mobile'];
        _info = documentSnapshot.data['info'];
        _user = userr;
        _userUID = userr.uid;
        _countryCode = documentSnapshot.data['countryCode'];
      }
      print('Get Data');
      notifyListeners();
    });
  }

  signOut() {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    CollectionReference user = Firestore.instance.collection('users');

    _firebaseAuth.signOut();
    Future.delayed(Duration(seconds: 2), () => resetUserData());

    return user.document(this._mobile).updateData({'token': ''});
  }

  resetUserData() {
    name = null;
    email = null;
    mobile = null;
    country = null;
    age = null;
    gender = null;
    info = null;
    countryCode = null;
    user = null;
    userUID = null;
  }
}

class PatientUser extends User {}

class DoctorUser extends User {}

class AdminUser extends User {}
