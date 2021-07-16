import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_higenx_app/globle.dart';
import 'package:flutter_higenx_app/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Globle.isRembemerMe = prefs.getBool('check');
  if(Globle.isRembemerMe) {
    Globle.email  = prefs.getString('email');
    Globle.password  = prefs.getString('password');
  }
}
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telematics Solution',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreens(),
    );
  }
}
