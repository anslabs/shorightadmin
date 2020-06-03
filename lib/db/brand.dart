
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class BrandService {
  Firestore _firestore = Firestore.instance;
  String ref = "brands";

  void createBrand(String name, String image) {
    _firestore.collection(ref).add({
      'brand': name,
      'bimage': image,
    });
  }

  Future<List<DocumentSnapshot>> getBrands() =>
     _firestore.collection(ref).getDocuments().then((snaps) {
      return snaps.documents;
    });

  Future<DocumentSnapshot>  getBrandById(String id) =>
      _firestore.collection(ref).document(id).get().then((doc) {
        return doc;
      });


  Future<List<DocumentSnapshot>> getSuggestion(String suggestion) =>
      _firestore.collection(ref).where('brand', isEqualTo:suggestion).getDocuments().then((snap){
        return snap.documents;
      });




}