import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_tools/router/routers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 667),
      builder: () => MaterialApp(
        title: "测试",
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.pink,
        ),
        initialRoute: '/',
        navigatorObservers: [MyRouter.routeObserver],
        onGenerateRoute: MyRouter.onGenerateRoute,
        builder: (BuildContext context, Widget? child) {
          return Overlay(
            initialEntries: [
              OverlayEntry(builder: (BuildContext ctx) => child ?? Container()),
              OverlayEntry(builder: (BuildContext ctx) => Container()),
            ],
          );
        },
      ),
    );
  }
}
