import 'package:flutter/material.dart';
import 'package:my_tools/ui/tomato/list_item.dart';

class TomatoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TomatoPageState();
  }
}

class _TomatoPageState extends State<TomatoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            ListItem(
              icon: Icon(
                Icons.today,
                color: Colors.pink,
              ),
              title: "今天",
              time: "7",
              times: 5
            )
          ],
        ),
      ),
    );
  }
}
