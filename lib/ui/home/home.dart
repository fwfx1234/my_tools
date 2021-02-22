import 'package:flutter/material.dart';
import 'package:my_tools/ui/home/home_item.dart';
import 'package:my_tools/router/routers.dart';
import 'package:flutter_screenutil/size_extension.dart';

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
              padding: EdgeInsets.all(5.0.w),
              decoration: BoxDecoration(color: Color(0xffe1f5fe)),
              child: GridView.count(
                childAspectRatio: 1.8,
                crossAxisCount: 2,
                children: [
                  HomeItem(
                    image: Image.asset("lib/assets/chrome.png"),
                    title: "浏览器",
                    content: "还没完善",
                    onTap: () {
                      Navigator.of(context).pushByUrl("/browser");
                    },
                  ),
                  HomeItem(
                    image: Image.asset("lib/assets/tomato.png"),
                    title: "小番茄",
                    content: "用于计划学习的",
                    onTap: () {
                      Navigator.of(context).pushByUrl("/tomato");
                    },
                  )
                ],
              ))),
    );
  }
}
