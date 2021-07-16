import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_higenx_app/Screens/Login/login_screen.dart';
import 'package:flutter_higenx_app/about/about.dart';
import 'package:flutter_higenx_app/main_screen/background.dart';
import 'package:flutter_higenx_app/model/category_model.dart';
import 'package:flutter_higenx_app/reset_password/reset_password.dart';
import 'package:flutter_higenx_app/weviewcontainer_service.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../globle.dart';
import '../weviewcontainer.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final appTitle = 'IoT Data';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      color: kPrimaryLightColor1,
      home: MyHomePage(title: appTitle),
    );
  }
}

Future<void> share() async {
  await FlutterShare.share(
      title: 'Example share',
      text: 'Example share text',
      linkUrl: 'https://flutter.dev/',
      chooserTitle: 'Example Chooser Title');
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("IoT Data"),
          elevation: 0,
          backgroundColor: kPrimaryLightColor1,
        ),
        body: Background(
            child: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 1,
                children: <Widget>[
                  Container(
                    child: FutureBuilder<CategoryModel>(
                        future: getCatgory(),
                        builder: (BuildContext context,
                            AsyncSnapshot<CategoryModel> snapshot) {
                          if (snapshot.hasData) {
                            return GridView.builder(
                                itemCount: snapshot.data.data.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.of(context).orientation ==
                                              Orientation.landscape
                                          ? 3
                                          : 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                //physics:BouncingScrollPhysics(),
                                padding: EdgeInsets.all(10.0),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        WebViewContainer(
                                                            snapshot.data.data[index])));
                                        print(Globle.driver);
                                      });
                                      // Navigator.of(context).pushNamed(RouteName.GridViewCustom);
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.network(
                                                "http://iotsolution.unifiedtnc.com/${snapshot.data.data[index].icon}",
                                                height: 70,
                                                width: 70,
                                              ),
                                              Flexible(
                                                child: Text(
                                                    snapshot.data.data[index]
                                                        .category,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return Container(
                                child:
                                    Center(child: Icon(Icons.error_outline)));
                          } else {
                            return Container(
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }
                        }),
                  ),

                  // Container(
                  //   padding: const EdgeInsets.all(4),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         Navigator.of(context).push(CupertinoPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 WebViewContainer(
                  //                     Globle.driver, 'Cold Chain')));
                  //         print(Globle.driver);
                  //       });
                  //     },
                  //     child: new Card(
                  //       child: new Padding(
                  //         padding: EdgeInsets.all(15.0),
                  //         child: Column(
                  //           children: [
                  //             Expanded(
                  //               child: Column(
                  //                 children: <Widget>[
                  //                   Image.asset(
                  //                     "assets/icons/cold_chain.png",
                  //                     height: size.height * 0.1,
                  //                   ),
                  //                   // The long text inside this column overflows. Remove the row and column above this comment and the text wraps.
                  //                   Expanded(
                  //                     child: Container(
                  //                       child: Text(
                  //                         "Cold Chain",
                  //                         style: TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                             fontSize: 15.0,
                  //                             color: Colors.black),
                  //                         textAlign: TextAlign.center,
                  //                       ),
                  //                     ),
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.all(4),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         Navigator.of(context).push(CupertinoPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 WebViewContainer(
                  //                     Globle.vehicle, 'Level Measurement')));
                  //
                  //         // Navigator.of(context).pushAndRemoveUntil(
                  //         //     MaterialPageRoute(
                  //         //       builder: (BuildContext context) => WebViewContainer(Globle.vehicle, 'Vehicle Data'),),
                  //         //         (Route<dynamic> route) => false);
                  //         print(Globle.vehicle);
                  //       });
                  //     },
                  //     child: new Card(
                  //       child: new Padding(
                  //         padding: EdgeInsets.all(10.0),
                  //         child: Column(
                  //           children: <Widget>[
                  //             Image.asset(
                  //               "assets/icons/level_measurement.png",
                  //               height: size.height * 0.1,
                  //             ),
                  //             // The long text inside this column overflows. Remove the row and column above this comment and the text wraps.
                  //             Expanded(
                  //               child: Container(
                  //                 child: Text("Level Measurement",
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         fontSize: 15.0,
                  //                         color: Colors.black),
                  //                     textAlign: TextAlign.center),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.all(4),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         Navigator.of(context).push(CupertinoPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 WebViewContainer(
                  //                     Globle.temp, 'Temperature/Humidity')));
                  //
                  //         // Navigator.of(context).pushAndRemoveUntil(
                  //         //     MaterialPageRoute(
                  //         //       builder: (BuildContext context) => WebViewContainer(Globle.temp, 'Temperature Data'),),
                  //         //         (Route<dynamic> route) => false);
                  //         print(Globle.temp);
                  //       });
                  //     },
                  //     child: new Card(
                  //       child: new Padding(
                  //         padding: EdgeInsets.all(10.0),
                  //         child: Column(
                  //           children: <Widget>[
                  //             Image.asset(
                  //               "assets/icons/temp_humidity.png",
                  //               height: size.height * 0.1,
                  //             ),
                  //             // The long text inside this column overflows. Remove the row and column above this comment and the text wraps.
                  //             Expanded(
                  //               child: Container(
                  //                 child: Text(
                  //                   "Temperature/Humidity",
                  //                   style: TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 15.0,
                  //                       color: Colors.black),
                  //                   textAlign: TextAlign.center,
                  //                 ),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        )),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: Column(children: [
            Flexible(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).platform ==
                                      TargetPlatform.iOS
                                  ? kPrimaryLightColor1
                                  : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/profile.jpeg',
                                  ),
                                  // Image.asset(
                                  //   "assets/images/profile.jpeg",
                                  //   height: size.height * 0.1,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: Text(
                                      Globle.name,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        Globle.email,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Center(
                            //     child: Text('Hassan Raza',
                            //           style:
                            //               TextStyle(fontSize: 18, color: Colors.white),
                            //         ),
                            //     ),
                            // Center(
                            //   child: Text(
                            //     'hr12@gamil.com',
                            //     style: TextStyle(fontSize: 18, color: Colors.white),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor1,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.lock_open),
                    title: Text('Reset Password'),
                    onTap: () {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  ResetPassword()))
                          .then((value) => Navigator.pop(context));
                    },
                  ),
                  const Divider(height: 1.0, color: Colors.grey),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('About App'),
                    onTap: () {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(
                              builder: (BuildContext context) => About()))
                          .then((value) => Navigator.pop(context));
                    },
                  ),
                  const Expanded(child: SizedBox()),
                  const Divider(height: 1.0, color: Colors.grey),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share App'),
                    onTap: share,
                  ),
                  const Expanded(child: SizedBox()),
                  const Divider(height: 1.0, color: Colors.grey),
                  ListTile(
                    leading: Icon(Icons.branding_watermark),
                    title: Text('Terms & condition'),
                    onTap: () {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  WebViewContainerService(
                                      Globle.terms, 'Terms & Condition')))
                          .then((value) => Navigator.pop(context));
                    },
                  ),
                  const Expanded(child: SizedBox()),
                  const Divider(height: 1.0, color: Colors.grey),
                  ListTile(
                    leading: Icon(Icons.privacy_tip),
                    title: Text('Privacy Policy'),
                    onTap: () {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  WebViewContainerService(
                                      Globle.privacy, 'Privacy Policy')))
                          .then((value) => Navigator.pop(context));
                    },
                  ),
                  const Expanded(child: SizedBox()),
                  const Divider(height: 1.0, color: Colors.grey),
                  ListTile(
                    leading: Icon(Icons.contact_mail_rounded),
                    title: Text('Contact Us'),
                    onTap: () {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  WebViewContainerService(
                                      Globle.contact, 'Contact Us')))
                          .then((value) => Navigator.pop(context));
                    },
                  ),
                  const Expanded(child: SizedBox()),
                  const Divider(height: 1.0, color: Colors.grey),
                ],
              ),
            ),
            ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Logout"),
                onTap: () {
                  Navigator.of(context).pushReplacement(CupertinoPageRoute(
                      builder: (BuildContext context) => LoginScreen()));
                }),
          ]),
        ));
  }

  Future<CategoryModel> getCatgory() async {
    var request = http.Request('GET',
        Uri.parse('http://iotsolution.unifiedtnc.com/api/get_category.php'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var response2 = await response.stream.bytesToString();
      var jsonResponse = json.decode(response2);
      print("Success get values");
      return CategoryModel.fromJson(jsonResponse);
    } else {
      print(response.reasonPhrase);
    }
  }
}
