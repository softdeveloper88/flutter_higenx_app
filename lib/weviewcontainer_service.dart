import 'package:flutter/material.dart';
import 'package:flutter_higenx_app/constants.dart';
import 'package:flutter_higenx_app/globle.dart';
import 'package:flutter_higenx_app/model/category_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainerService extends StatefulWidget {
  final url;
  final title;

  WebViewContainerService(this.url,this.title);

  @override
  createState() => _WebViewContainerState(this.url,this.title);
}

class _WebViewContainerState extends State<WebViewContainerService> {
  final _url;
  final _title;
  final _key = UniqueKey();

  _WebViewContainerState(this._url,this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor1,
        title: Text(_title),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: _url,
            ),
          ),
        ],
      ),
    );
  }

}
