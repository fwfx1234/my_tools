import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_tools/router/routers.dart';

void gotoBrowser(BuildContext context, String url, {bool isShowNavBar: false}) {
  Navigator.pushNamed(context, '/webview', arguments: {'url': url, 'isShowNavBar': isShowNavBar});
}