import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_higenx_app/weviewcontainer.dart';
class WebviewGraph extends StatefulWidget {
  String url;
  WebviewGraph(String url);

  @override
  _WebviewGraphState createState() => _WebviewGraphState();
}

class _WebviewGraphState extends State<WebviewGraph> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container());
      // : WebViewContainer('https://datastudio.google.com/embed/u/0/reporting/1WG671Rv2pJtu2lgszvGGE6h-5qEZ_fmB/page/obhJB', 'MindOrks'),


  }
}