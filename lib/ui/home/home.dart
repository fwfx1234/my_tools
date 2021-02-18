import 'package:flutter/material.dart';
import 'package:my_tools/ui/home/home_item.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(color: Color(0xffe1f5fe)),
              child: GridView.count(
                childAspectRatio: 1.3,
                crossAxisCount: 2,
                children: [
                  HomeItem(
                      image: Image.asset("lib/assets/chrome.png"), title: "浏览器"),
                ],
              ))),
    );
  }
}
