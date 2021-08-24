import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_tools/ui/demo/scroller_to_index.dart';
import 'package:my_tools/ui/demo/test_uprate.dart';
class DemoBean {
  String title;
  Widget page;
  DemoBean(this.title, this.page);
}
class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<DemoBean> list = [
      DemoBean("滚动到指定位置", ScrollerToIndexDemo()),
      DemoBean("测试更新", TestUpdatePage())

    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('demo'),
      ),
      body: SafeArea(
        child: ListView.builder(itemCount: list.length, itemBuilder: (context, pos)  {
          return InkWell(
            splashColor: Colors.blue,
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => list[pos].page));
            },
            child: Container(
              height: 50.0.w,
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12))),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(list[pos].title),
              ),
            ),
          );
        })
      ),
    );
  }
}
