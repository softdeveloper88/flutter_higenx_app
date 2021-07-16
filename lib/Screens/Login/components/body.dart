import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_higenx_app/Screens/Signup/signup_screen.dart';
import 'package:flutter_higenx_app/components/already_have_an_account_acheck.dart';
import 'package:flutter_higenx_app/components/rounded_button.dart';
import 'package:flutter_higenx_app/components/text_field_container.dart';
import 'package:flutter_higenx_app/globle.dart';
import 'package:flutter_higenx_app/main_screen/navigation_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import 'background.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

bool _isRembemerMe = false;

class _BodyState extends State<Body> {
  @override
  void initState() {
    _passwordVisible = false;
    _isRembemerMe = Globle.isRembemerMe;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = ProgressDialog(context);
    Size size = MediaQuery.of(context).size;
    pr = ProgressDialog(context, showLogs: false);
    pr.style(
        message: 'Please wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/playstore.png",
              height: size.height * 0.3,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "IoT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.blue),
                  ),
                  Text(
                    " Solution",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: kPrimaryLightColor1),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            textSection(),
            RoundedButton(
              text: "Login",
              press: () async {
                // emailController.text == "" || passwordController.text == "" ? null : () {
                  if (emailController.text == "" ||
                      passwordController.text == "") {
                    Fluttertoast.showToast(
                        msg: "Please enter email and password",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    //For normal dialog
                    try {
                        final user = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text).then((user) {
                          if (user.isEmailVerified) {
                            pr.show();
                            signIn(emailController.text, passwordController.text,
                                pr);
                          }else{
                            Fluttertoast.showToast(
                                msg: "Please Verify your email first check email inbox",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        });

                    } catch (e) {
                      print(e);
                    }
                  }

              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void signIn(String email, pass, ProgressDialog pr) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass};
    var jsonResponse;
    var response = await http.post(Uri.parse(Globle.login), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        print(jsonResponse.toString());

        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> data = map["data"];
        Globle.userId = data[0]['user_id'];
        Globle.name = data[0]['name'];
        Globle.email = data[0]['email'];
        Globle.password = data[0]['password'];
        graphData(data[0]['user_id'] as String, pr);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Password or email is incorrect",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      pr.hide();
      print(response.body);
    }
  }

  void graphData(
    String uuid,
    ProgressDialog pr,
  ) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Map data = {'user_id': uuid};
    var jsonResponse;
    var response =
        await http.get(Uri.parse(Globle.getGraph + "?user_id=" + uuid));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        Map<String, dynamic> map = json.decode(response.body);
        Future.delayed(Duration(seconds: 2)).then((value) {
          pr.hide().whenComplete(() async {
            if (_isRembemerMe) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('check', _isRembemerMe);
              prefs.setString('email', emailController.text);
              prefs.setString('password', passwordController.text);
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('email', "");
              prefs.setString('password', "");
              prefs.setBool('check', _isRembemerMe);
            }
            Globle.data = map["data"];
            Navigator.of(context).pushReplacement(CupertinoPageRoute(
                builder: (BuildContext context) => NavigationDrawer()));
          });
        });
        // if (data.length !=null) {
        //   for (var i = 0; i < data.length; i++) {
        //     if (data[i]['gr_category'].toString() == "Air Quality Co2/CoV") {
        //       print("1" + data[i]['gr_url']);
        //       Globle.fuel = data[i]['gr_url'];
        //     } else if (data[i]['gr_category'].toString() ==
        //         "Cold Chain") {
        //       print(data[i]['gr_url']);
        //       Globle.driver = data[i]['gr_url'];
        //     } else
        //     if (data[i]['gr_category'].toString() == "Level Measurement") {
        //       print(data[i]['gr_url']);
        //       Globle.vehicle = data[i]['gr_url'];
        //     } else
        //     if (data[i]['gr_category'].toString() == "Temperature/Humidity") {
        //       print(data[i]['gr_url']);
        //       Globle.temp = data[i]['gr_url'];
        //     }
        //   }
        // }
      }
    }
  }

// Container buttonSection(BuildContext context) {
//   return Container(
//     width: MediaQuery.of(context).size.width,
//     height: 40.0,
//     padding: EdgeInsets.symmetric(horizontal: 15.0),
//     margin: EdgeInsets.only(top: 15.0),
//     child: RaisedButton(
//       onPressed: () {
//         // emailController.text == "" || passwordController.text == ""
//         //     ? null
//         //     : () {
//                 // ignore: unnecessary_statements
//                 signIn(emailController.text, passwordController.text);
//                 // print("email" + emailController.text);
//               // };
//       },
//       elevation: 0.0,
//       color: Colors.purple,
//       child: Text("Sign In", style: TextStyle(color: Colors.white70)),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
//     ),
//   );
// }
  final TextEditingController emailController =
      new TextEditingController(text: Globle.email);
  final TextEditingController passwordController =
      new TextEditingController(text: Globle.password);
  bool _passwordVisible = false;
  String email;

  Container textSection() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFieldContainer(
            child: TextField(
              controller: emailController,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ),
          TextFieldContainer(
            child: TextField(
              obscureText: !_passwordVisible,
              controller: passwordController,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          CheckboxListTile(
            checkColor: Theme.of(context).primaryColor,
            activeColor: kPrimaryLightColor1,
            value: _isRembemerMe??false,
            onChanged: (value) {
              setState(() {
                _isRembemerMe = value;
              });
            },
            title: Text("Remember me"),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

// Future<void> isRemember(bool isRememberMe) async {
//   if(isRememberMe){
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('check', isRememberMe);
//     prefs.setString('email', emailController.text);
//     prefs.setString('password', passwordController.text);
//   }else{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('email', "");
//     prefs.setString('password', "");
//     prefs.setBool('check', isRememberMe);
//   }
//
// }

}
