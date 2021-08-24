import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_tools/ui/browser/browser.dart';
import 'package:my_tools/ui/demo/demo.dart';
import 'package:my_tools/ui/home/home.dart';
import 'package:my_tools/ui/tomato/tomato.dart';
import 'package:my_tools/ui/webview/webview.dart';

class MyRouter {
  static final List<String> _needAuthRoute = ['/user_center', '/coupon'];

  static Map<String, Widget Function(BuildContext, {Object? argument})>
      _routers = {
    "/": (context, {Object? argument}) => HomePage(),
    '/browser': (context, {Object? argument}) => BrowserPage(),
    '/tomato': (context, {Object? argument}) => TomatoPage(),
    '/webview': (context, {Object? argument}) {
      var params = argument as Map;
      String url = params['url'] ?? '';
      assert(!url.startsWith('http'), "url 不合法");
      bool isShowNavBar = params['isShowNavBar'];
      return WebViewPage(
        url: url,
        isShowNavBar: isShowNavBar,
      );
    },
    '/demo': (context, {Object? argument}) => DemoPage()
  };

  static Future<bool> _isNeedLogin(
      BuildContext context, String routeName) async {
    if (!_needAuthRoute.contains(routeName)) {
      return false;
    }
    return false;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return CupertinoPageRoute(builder: (context) {
      String? routeName = settings.name;
      if (routeName == null) {
        return HomePage();
      }
      return _routers[routeName]!(context, argument: settings.arguments);
    });
  }

  static Future<bool?> pushNamed(BuildContext context, String routeName,
      {Object? arguments}) async {
    if (await _isNeedLogin(context, routeName)) {
      await Navigator.pushNamed(context, '/login',
          arguments: {'routeName': routeName, 'arguments': arguments});
      return false;
    } else {
      await Navigator.pushNamed(context, routeName, arguments: arguments);
      return true;
    }
  }
}
