import 'package:flutter/material.dart';
import 'package:flutter_higenx_app/constants.dart';
import 'package:flutter_higenx_app/globle.dart';
import 'package:flutter_higenx_app/model/category_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  Datum data;

  WebViewContainer(this.data);

  @override
  createState() => _WebViewContainerState(this.data);
}

class _WebViewContainerState extends State<WebViewContainer> {
  Datum _data;
  final _key = UniqueKey();

  _WebViewContainerState(this._data);

  @override
  Widget build(BuildContext context) {
    // String url = getSelectedUrl(_data)??"http://";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor1,
        title: Text(_data.category),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: getSelectedUrl(_data)??"http://",
            ),
          ),
        ],
      ),
    );
  }

  String getSelectedUrl(Datum data) {
    String url="";

      if (Globle.data!=null) {
        for (int i = 0; i < Globle.data.length; i++) {
          if (Globle.data[i]['gr_category'].toString() == _data.id.toString()) {
            url = Globle.data[i]['gr_url'];
            break;
          }
        }
      }

    return url;
  }
}
