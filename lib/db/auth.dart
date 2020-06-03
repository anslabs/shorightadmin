import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

abstract class BaseAuth{
  Future<FirebaseUser> googleSignIn();
}

class Auth implements BaseAuth{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> googleSignIn() async{
   final GoogleSignIn googleSignIn = GoogleSignIn();
   final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
   final GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
   AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

   try{
     AuthResult authUser = await _firebaseAuth.signInWithCredential(credential);
     FirebaseUser firebaseUser = authUser.user;
     return firebaseUser;
   }
    catch(e){
      print(e.toString());
      return null;
    }

  }
}