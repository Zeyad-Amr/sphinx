/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Services with ChangeNotifier {
  List<Service> _serviceItems = [];
  List<Service> get serviceItems {
    return _serviceItems;
  }

  CollectionReference service = Firestore.instance.collection('services');

  Future<void> addServices({String nameEn, String nameAr, int pE, int pF}) {
    return service
        .document(nameEn)
        .setData({
          'name_en': nameEn,
          'name_ar': nameAr,
          'priceEgy': pE,
          'priceForg': pF
        })
        .then((value) => print("User service"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> getServices() async {
    service.getDocuments().then((QuerySnapshot doc) => {
          doc.documents.forEach((item) {
            print('1');
            print(item['name_ar']);
            _serviceItems.add(Service(
              nameAr: item['name_ar'],
              nameEn: item['name_en'],
              priceEgy: item['priceEgy'],
              priceForg: item['priceForg'],
            ));
          })
        });

    notifyListeners();
  }
}

class Service {
  final String nameEn;
  final String nameAr;
  final String priceEgy;
  final String priceForg;

  Service({
    @required this.nameEn,
    @required this.nameAr,
    @required this.priceEgy,
    @required this.priceForg,
  });
}
 */
