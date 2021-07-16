import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_higenx_app/Screens/Login/login_screen.dart';
import 'package:flutter_higenx_app/Screens/Signup/components/background.dart';
import 'package:flutter_higenx_app/components/rounded_button.dart';
import 'package:flutter_higenx_app/components/text_field_container.dart';
import 'package:flutter_higenx_app/globle.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import '../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _confirmPassword, _password = "";
  final _formKey = GlobalKey<FormState>();
  FocusNode _confirmPasswordFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

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
                    " Data",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: kPrimaryLightColor1),
                  ),
                ],
              ),
            ),
            Form(key: _formKey, child: textSection()),
            RoundedButton(
              text: "RESET PASSWORD",
              press: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    pr.show();
                    resetPassword(_password, pr);
                    // signUp(nameController.text.toString(),emailController.text.toString(),passwordController.text.toString());
                  });
                }
              },
            ),
            SizedBox(height: size.height * 0.02),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  // final TextEditingController nameController = new TextEditingController();
  // final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;

  Container textSection() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFieldContainer(
            child: TextFormField(
              focusNode: _passwordFocusNode,
              validator: (password) {
                Pattern pattern =
                    r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(password))
                  return 'Invalid password (password must be 6 character with number and character)';
                else
                  return null;
              },
              onSaved: (password) => _password = password,
              controller: passwordController,
              obscureText: !_passwordVisible,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "New password",
                border: OutlineInputBorder(),
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
          TextFieldContainer(
            child: TextFormField(
              focusNode: _confirmPasswordFocusNode,
              validator: (confirmPassword) {
                Pattern pattern =
                    r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                RegExp regex = new RegExp(pattern);
                if (passwordController.text.toString() != confirmPassword)
                  return 'Password not matched';
                else
                  return null;
              },
              onSaved: (confirmPassword) => _confirmPassword = confirmPassword,
              // controller: passwordController,
              obscureText: !_passwordVisible2,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Confirm Password",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible2 = !_passwordVisible2;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetPassword(String pass, ProgressDialog pr) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'user_id': Globle.userId, 'password': pass};
    var jsonResponse;
    var response = await http.post(Uri.parse(Globle.resetPassword), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        print(jsonResponse.toString());
        setState(() {
          pr.hide();
          Fluttertoast.showToast(
              msg: "Password reset successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()),
              (Route<dynamic> route) => false);
        });
      }
    } else {
      setState(() {
        Fluttertoast.showToast(
            msg: "Some thing went wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        pr.hide();
      });
      print(response.body);
    }
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    _passwordVisible = false;
    _passwordVisible2 = false;
  }
}
