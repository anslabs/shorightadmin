import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shorightadmin/model/user_model.dart';

class UserServices{
 // FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  final CollectionReference userCollection = Firestore.instance.collection('users');
//  String ref = "users";
//
//  createUser(Map value){
//    String id = value["userId"];
//      //_firebaseDatabase.reference().child("$ref/$id").push().set(value).then((onValue){}).catchError((onError) {
//      _firebaseDatabase.reference().child("$ref/$id").set(value).then((onValue){}).catchError((onError) {
//    });
//  }

  final String uid;

  UserServices(this.uid);

  Future updateUserData(UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("photoUrl", userModel.photoUrl);
    preferences.setString("username", userModel.username);
    preferences.setString("phoneNumber", userModel.phoneNumber);
    preferences.setString("email", userModel.email);
    preferences.setString("gender", userModel.gender);

    return await userCollection.document(uid).setData(userModel.toJson());
  }
  
  Future<UserModel> findUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    DocumentReference documentReference = await userCollection.document(uid);
    if(documentReference == null){
      documentReference.get().then((value){
        final  response = UserModel.fromJson(json.decode(value.toString()));
        preferences.setString("photoUrl", response.photoUrl);
        preferences.setString("username", response.username);
        preferences.setString("phoneNumber", response.phoneNumber);
        preferences.setString("email", response.email);
        preferences.setString("gender", response.gender);
        return response;
      }).catchError((error){
        debugPrint(error);
      });
    }
    return null;
  }
}