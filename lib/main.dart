import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shorightadmin/pages/AddProduct.dart';
import 'package:shorightadmin/pages/Admin.dart';
import 'package:shorightadmin/pages/Login.dart';
import 'package:shorightadmin/pages/add_brands.dart';
import 'package:shorightadmin/pages/add_category.dart';
import 'package:shorightadmin/pages/add_subcategory.dart';
import 'package:shorightadmin/provider/user_provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: UserProvider.initialize()),
  ] ,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.deepOrange
        ),
        home: ScreensController(),
      )
    )
  );
}
class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    switch(user.status){
      case Status.Uninitialized: return AfterSplash();
      case Status.Authenticating: return Login();
      case Status.Unauthenticated: return Login();
      case Status.Authenticated: return Admin();
      default: return Login();
    }
  }
}

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {


    return  SplashScreen(
        seconds: 10,
       navigateAfterSeconds:  AfterSplash(),
        title: new Text('SHOPRIGHT ADMIN',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),),
        image:  Image.asset('assets/images/srt.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: ()=>print("Flutter"),
        loaderColor: Colors.redAccent
    );
    
  }
}

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {
  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.deepOrange : Colors.deepOrange,
          ),
        );
      },
    );
  }
}



