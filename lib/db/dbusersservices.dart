import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FsUsersServices{
  Firestore _firestore = Firestore.instance;
  String collection = "users";
  void createUser(Map data){
    _firestore.collection(collection).document(data['userId']).setData(data);
  }
}

//class DbUserServices{
//  FirebaseDatabase _database = FirebaseDatabase.instance;
//  String ref = 'users';
//  createUser(Map value){
//    _database.reference().child(ref).push().set(
//      value
//    ).catchError((e){
//      print(e.toString());
//    });
//  }
//}