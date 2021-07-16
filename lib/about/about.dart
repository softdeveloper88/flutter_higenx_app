import 'package:flutter/material.dart';

import '../constants.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor1,
        title: Text("About"),
      ),
      body: Column(
        children: [
      Expanded(
      child:Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(
              "About",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.blue),
            ),
            textSection(),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    ]
    ),
    );
  }

  Container textSection() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          Text(
            "The Telematics Solution app is designed to give you the latest information on all the critical data to run your business efficient and effectively. Improve your business by identifying issues before they become a problem. The data history can be viewed by selecting the calendar at the top bar in each category and selecting the date range.",
            style: TextStyle(fontSize: 18, letterSpacing: 1),
          )
        ],
      ),
    );
  }
}
