import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InnerWidget extends StatelessWidget {
  final String text;
  const InnerWidget(this.text);
  @override
  Widget build(BuildContext context) {
    debugPrint("rebuild");
    debugPrint("runtimeType: $runtimeType key: $key hashcode: $hashCode");
    return Text("inner $text");
  }
}


class TestUpdatePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _TestUpdatePageState();
  }
}
class _TestUpdatePageState extends State<TestUpdatePage> {
  final int _count = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: InkWell(
        onTap: () {
          setState(() {
            debugPrint("click");
          });
        },
        child: Container(
          width: 300.0,
          height: 300.0,
          color: Colors.green,
          child: const InnerWidget('click 1 times'),
        ),
      ),
    );
  }

}