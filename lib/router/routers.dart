import 'package:flutter/material.dart';
import 'package:my_tools/router/annotation.dart';
import 'package:my_tools/ui/browser/browser.dart';
import 'package:my_tools/ui/home/home.dart';
import 'package:my_tools/ui/tomato/tomato.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (content) => HomePage(),
  '/browser': (context) => BrowserPage(),
  '/tomato': (context) => TomatoPage(),
};

Route _createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

extension NavigatorExtension on NavigatorState {
  pushByUrl(String name) {
    var builder = routes[name];
    this.push(_createRoute(builder(this.context)));
  }
}

@MyRouteRoot()
class RouterRoot {
  RouterRoot();
}