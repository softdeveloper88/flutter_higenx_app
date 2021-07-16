import 'package:flutter/material.dart';
import 'package:flutter_higenx_app/constants.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(color: kPrimaryLightColor1),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: size.height * 0.15,
                    ),
                    child
                    // The long text inside this column overflows. Remove the row and column above this comment and the text wraps.
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
