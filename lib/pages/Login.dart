import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorightadmin/db/users.dart';
import 'package:shorightadmin/model/user_model.dart';
import 'package:shorightadmin/pages/Admin.dart';
import 'package:shorightadmin/provider/user_provider.dart';
import 'package:shorightadmin/utils/loading.dart';


import 'SignUp.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool loading = false;
  bool isLoggedIn = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController _emaiController =TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  SharedPreferences sharedPreferences;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // isSignedIn();
  }

//  Future hanleSignIn0() async{
//    sharedPreferences = await SharedPreferences.getInstance();
//    setState(() {
//      loading = true;
//    });
//    GoogleSignInAccount googleUser  = await _googleSignIn.signIn();
//    GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;
//    FirebaseUser firebaseUser = await _firebaseAuth
//  }

  Future<FirebaseUser> handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    FirebaseUser firebaseUser = authResult.user;

    print("signed in " + firebaseUser.displayName);

    if (firebaseUser != null){
      assert(!firebaseUser.isAnonymous);
      assert(await firebaseUser.getIdToken() != null);

      final FirebaseUser currentUser = await _firebaseAuth.currentUser();

      assert(firebaseUser.uid == currentUser.uid);

//      final QuerySnapshot result = await Firestore.instance.collection("users").where("id", isEqualTo: firebaseUser.uid).getDocuments();
//      final List<DocumentSnapshot> documents = result.documents;

//      if(documents.length == 0){
//        //insert the user to our collection
//        Firestore.instance.collection("users").document(firebaseUser.uid).setData({
//          "id" : firebaseUser.uid,
//          "userName" : firebaseUser.displayName,
//          "profilPicture": firebaseUser.photoUrl,
//        });
//
////        await sharedPreferences.setString("id", firebaseUser.uid);
////        await sharedPreferences.setString("userName", firebaseUser.displayName);
////        await sharedPreferences.setString("photoUrl", firebaseUser.photoUrl);
//      }else{
////        await sharedPreferences.setString("id", documents[0]["id"]);
////        await sharedPreferences.setString("userName", documents[0]["userName"]);
////        await sharedPreferences.setString("photoUrl", documents[0]["profilPicture"]);
//      }

      UserServices userServices = new UserServices(firebaseUser.uid);
      final result = await userServices.findUserData();
      if(result != null){
        Fluttertoast.showToast(msg: "Connexion réussie");
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Admin()));
      }else{
        UserModel userModel = new UserModel(firebaseUser.email, firebaseUser.photoUrl, firebaseUser.phoneNumber, firebaseUser.displayName, null, null, null);
        userServices.updateUserData(userModel);
        Fluttertoast.showToast(msg: "Connexion réussie");
//        setState(() {
//          loading = false;
//        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Admin()));
      }
      Fluttertoast.showToast(msg: "Erreur de connexion", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP, backgroundColor: Colors.white, textColor: Colors.red);
    }else{
      Fluttertoast.showToast(msg: "Erreur de connexion", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP, backgroundColor: Colors.white, textColor: Colors.red);
    }
  }

  void isSignedIn() async {
    setState(() {
      loading = true;
    });
    // sharedPreferences = await SharedPreferences.getInstance();
    //1ere option
    await _firebaseAuth.currentUser().then((user){
      if(user != null){
        setState(() {
          isLoggedIn = true;
        });
      }
    });

    //2eme option
    isLoggedIn = await _googleSignIn.isSignedIn();

    if(isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Admin()));
    }

    setState(() {
      loading =false;
    });
  }
  final GlobalKey _globalKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _globalKey,
//      appBar: AppBar(
//        backgroundColor: Colors.white,
//        centerTitle: true,
//        title: Text('Login', style: TextStyle(color: Colors.red.shade900),),
//        elevation: 0.5,
//      ),
      body: user.status == Status.Authenticating ? Loading() : Stack(
        children: <Widget>[
//          Center(
//            child: FlatButton(onPressed: (){handleSignIn();},
//                child: Text("Inscription & Connexion avec Google", style: TextStyle(color: Colors.white),),
//              color: Colors.red.shade900,
//            ),
//          ),
        Image.asset('assets/images/w3.jpeg', fit: BoxFit.fill, width: double.infinity, height: double.infinity,),
        Container(
          color: Colors.black.withOpacity(0.8),
          width: double.infinity,
          height: double.infinity,
        ),
          Container(
              alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom:30.0, top: 30),
              child: Image.asset("assets/images/srtc.png", width: 200, height: 200,),
            ),
          ),
          Padding(
           padding: const EdgeInsets.only(top:200),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                child: Center(
                  child: Form(
                    key: _formkey,
                    child: ListView(
                      children: <Widget>[

                        Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.5),
                            elevation: 0.6,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: _emaiController,
                                decoration: InputDecoration(
                                    hintText: "Email *",
                                    icon: Icon(Icons.alternate_email),
                                    isDense: true,
                                    border: InputBorder.none),
                                keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                  if (value.isEmpty) {
                                    Pattern pattern =  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(value))  return 'Please make sure your email address is valid';
                                    else  return null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 14.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.5),
                            elevation: 0.6,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    hintText: "Password *",
                                    icon: Icon(Icons.vpn_key),
                                    isDense: true,
                                    border: InputBorder.none),
                                //keyboardType: TextInputType.,
                                validator: (value){
                                  if(value.isEmpty){
                                    return "The password can not be empty";
                                  }else if(value.length<6){
                                    return "password must be at least 6 characters long";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),



                        Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 14.0, 12.0, 14.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.deepOrange,
                            elevation: 0.6,
                            child: MaterialButton(
                              onPressed: ()async{
                                if(_formkey.currentState.validate()){
                                  if(!await user.signIn(_emaiController.text, _passwordController.text)){
                                    Fluttertoast.showToast(msg: "Echec de connexion");
                                  }
                                }
                              },
                              minWidth: MediaQuery.of(context).size.width,
                              child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center, ) ,
                            ),
                          ),
                        ),
                        Text("mot de passe oublié?", textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w300),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 14.0, 8.0, 8.0),
                          child: InkWell(
                            onTap:(){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
                            },
                            child: Text('Inscription', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w300), ),
                         ),
                      //    Text('Don\'t have an account? Click here Sign up', style: TextStyle(color: Colors.white)),
                        ),
                      //  Expanded(child: Container(),),
                        Divider(color:Colors.white),
                        Text("Autres type de connexion", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300,)),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 14.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                              elevation: 0.6,
                              child: MaterialButton(
                                minWidth: MediaQuery.of(context).size.width,
                                onPressed: (){
                                  handleSignIn();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
                                    SizedBox(width: 10,),
                                    Text(
                                        'Connexion avec Google',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300,)
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Visibility(
              visible: loading??true,
              child:Center(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.9),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              ),
          ),

        ],
      ),
//      bottomNavigationBar: Container(
//        child: Center(
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: FlatButton(
//              color: Colors.red.shade900,
//              onPressed: (){
//                handleSignIn();
//              },
//              child: Text('Connexion avec Google', style: TextStyle(color: Colors.white),),
//            ),
//          ),
//        ),
//      ),
    );
  }


}

