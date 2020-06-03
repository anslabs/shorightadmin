import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class TestService {
  Firestore _firestore = Firestore.instance;
  String ref = "tests";

  void createTest(String name) {
  _firestore.collection(ref).add({
    'test': name,
   });
  }

  Future<List<DocumentSnapshot>> getTests() =>
  _firestore.collection(ref).getDocuments().then((snaps) {
    return snaps.documents;
  });


  Future<List<DocumentSnapshot>> getSuggestion(String suggestion) =>
      _firestore.collection(ref).where('test', isEqualTo:suggestion).getDocuments().then((snap){
        return snap.documents;
      });




}