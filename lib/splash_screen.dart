import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Screens/Login/login_screen.dart';
class SplashScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
        imageBackground: AssetImage("assets/splashscreen.png"),
        // the widget to run after running your splashscreen for 1 sec
        navigateAfterSeconds: LoginScreen(),
        styleTextUnderTheLoader: TextStyle(),
        loaderColor: Colors.blue);
  }
}
