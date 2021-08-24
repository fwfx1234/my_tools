import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AutoScrollController extends ScrollController {
  final bool keepScrollOffset;
  final String? debugLabel;

  AutoScrollController(
      {double initialScrollOffset = 0.0,
      this.keepScrollOffset = true,
      this.debugLabel})
      : super(
            keepScrollOffset: keepScrollOffset,
            debugLabel: debugLabel,
            initialScrollOffset: initialScrollOffset) {
    debugPrint("AutoScrollController: create");
  }
  @override
  void attach(ScrollPosition position) {
    debugPrint("AutoScrollController: attach");

    super.attach(position);
  }
}

class ScrollerToIndexDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScrollerToIndexDemoState();
  }
}

class _ScrollerToIndexDemoState extends State<ScrollerToIndexDemo> {
  List<int> list = [];
  List<Key> keys = [];
  var _controller = AutoScrollController(initialScrollOffset: 0, debugLabel: 'info');

  @override
  void initState() {
    setState(() {
      list.addAll(List.generate(100, (index) {
        return Random().nextInt(300) + 20;
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("滚动到指定位置")),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
              itemCount: list.length,
              controller: _controller,
              itemBuilder: (context, pos) {
                 var box = Container(
                  height: list[pos].w,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.green)),
                  child: Center(
                    child: Text(pos.toString()),
                  ),
                );
                 return box;
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.animateTo(90.2,
              duration: Duration(microseconds: 500), curve: Curves.easeIn);
        },
        child: Text("12"),
      ),
    );
  }
}
