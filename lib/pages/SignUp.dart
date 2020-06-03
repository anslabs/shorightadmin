import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorightadmin/db/auth.dart';
import 'package:shorightadmin/db/dbusersservices.dart';
import 'package:shorightadmin/db/users.dart';
import 'package:shorightadmin/model/user_model.dart';
import 'package:shorightadmin/pages/Admin.dart';
import 'package:shorightadmin/provider/user_provider.dart';
import 'package:shorightadmin/utils/loading.dart';

import 'Login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool loading = false;
  bool isLoggedIn = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController _emaiController =TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cPasswordController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  String groupValue = "male";
  String gender;
  bool hidePAss = true;

  final GlobalKey _globalKey = GlobalKey<ScaffoldState>();


  Auth auth = Auth();
  FsUsersServices _fsUserServices = FsUsersServices();

  SharedPreferences sharedPreferences;
  //UserServices _userServices = UserServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _globalKey,
      body: user.status == Status.Authenticating ? Loading() : Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:20),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                child: Center(
                  child: Form(
                    key: _formkey,
                    child: ListView(
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Image.asset('assets/images/srtc.png', height: 180,),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.6),
                            elevation: 0.6,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                      hintText: "Nom prénoms *",
                                      icon: Icon(Icons.person),
                                      isDense: true,
                                      border: InputBorder.none),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.6),
                            elevation: 0.6,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _emaiController,
                                  decoration: InputDecoration(
                                      hintText: "Email *",
                                      icon: Icon(Icons.alternate_email),
                                      isDense: true,
                                      border: InputBorder.none),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      Pattern pattern =  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(value))  return 'Please make sure your email address is valid';
                                      else  return null;
                                    }
                                    return value;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.5),
                            elevation: 0.6,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _passwordController,
                                  obscureText: hidePAss,
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
                                trailing: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                                  setState(() {
                                    hidePAss = false;
                                  });
                                },),
                              ),
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.5),
                            elevation: 0.6,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _cPasswordController,
                                  obscureText: hidePAss,
                                  decoration: InputDecoration(
                                      hintText: "Confirm Password *",
                                      icon: Icon(Icons.vpn_key),
                                      isDense: true,
                                      border: InputBorder.none),
                                  //keyboardType: TextInputType.,
                                  validator: (value){
                                    if(value.isEmpty){
                                      return "The password can not be empty";
                                    }else if(value != _passwordController.text){
                                      return "password must be at least 6 characters long";
                                    }
                                    return null;
                                  },
                                ),
                                trailing: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                                  setState(() {
                                    hidePAss = false;
                                  });
                                },),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12 , 0.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.4),
                            child: Padding(
                              //color: Colors.white.withOpacity(0.4),
                              padding: EdgeInsets.all(4.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: ListTile(title: Text('Homme', textAlign: TextAlign.end, style: TextStyle(color: Colors.black54),),trailing: Radio(value: "male", groupValue: groupValue, onChanged: (e) => valueChanged(e)))),
                                  Expanded(child: ListTile(title: Text('Femme', textAlign: TextAlign.end, style: TextStyle(color: Colors.black54),),trailing: Radio(value: "female", groupValue: groupValue, onChanged: (e) => valueChanged(e)))),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 14.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.deepOrange,
                            elevation: 0.6,
                            child: MaterialButton(
//                              onPressed: () {
//                                registerUser();
//                              },
                              onPressed: ()async{
                                if(_formkey.currentState.validate()){
                                  if(!await user.signUp(_nameController.text, _emaiController.text, _passwordController.text)){
                                    Fluttertoast.showToast(msg: "Echec de Inscription");
                                  }
                                }
                              },

                              minWidth: MediaQuery.of(context).size.width,
                              child: Text("Inscription", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center, ) ,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 14.0, 8.0, 8.0),
                          child: InkWell(
                            onTap:(){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                            },
                            child: Text('J\'ai déjà un compte', textAlign: TextAlign.center, style: TextStyle(color: Colors.deepOrangeAccent),),
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
                                  signInWithGoogle();
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
    );
  }

  valueChanged(e) {
    setState(() {
      if(e == "male"){
        groupValue = e;
      }
      else if (e == "female"){
        groupValue = e;
      }
    });
  }

  Future<String> signInWithGoogle() async {
    print("User Sign Up with google");
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

      UserServices userServices = new UserServices(firebaseUser.uid);
      UserModel userModel = new UserModel(firebaseUser.email, firebaseUser.photoUrl, firebaseUser.phoneNumber, firebaseUser.displayName, gender, null, null);
      final result = await userServices.updateUserData(userModel);

      Fluttertoast.showToast(msg: "Connexion réussie");
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Admin()));
    }else{
      Fluttertoast.showToast(msg: "Erreur de connexion", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP, backgroundColor: Colors.white, textColor: Colors.red);
    }
  }

  void signOutGoogle() async{
    await _googleSignIn.signOut();

    print("User Sign Out");
  }

  Future registerUser() async {
    Map value ;
    FormState formState = _formkey.currentState;
    if(formState.validate()){
      FirebaseUser user = await _firebaseAuth.currentUser();
      if(user == null){
        //create our user
       final result = _firebaseAuth.createUserWithEmailAndPassword(email: _emaiController.text, password: _passwordController.text);
       result.then((value){
         UserServices userServices  = new UserServices(value.user.uid);
         UserModel userModel = new UserModel(value.user.email,
             value.user.photoUrl, value.user.phoneNumber, value.user.displayName, gender, null, null);
         userServices.updateUserData(userModel);

         Fluttertoast.showToast(msg: "Connexion réussie");
         setState(() {
           loading = false;
         });
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Admin()));
       }).catchError((error){
         Fluttertoast.showToast(msg: "Erreur de connexion", textColor: Colors.red);
       });
      }else{
        UserServices userServices  = new UserServices(user.uid);
        UserModel userModel = new UserModel(user.email, user.photoUrl, user.phoneNumber, user.displayName, gender, null, null);
        final result = await userServices.updateUserData(userModel);

        Fluttertoast.showToast(msg: "Connexion réussie");
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Admin()));
      }
    }
  }
}
