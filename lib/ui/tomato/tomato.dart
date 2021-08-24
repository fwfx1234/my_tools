import 'package:flutter/material.dart';
import 'package:my_tools/api/api_knowledge.dart';
import 'package:my_tools/db/knowledge.dart';
import 'package:my_tools/ui/tomato/list_item.dart';
import 'package:my_tools/beans/tomato/knowledge_bean.dart';
import 'package:my_tools/utils/common.dart';
import 'package:sqflite/sqflite.dart';

class TomatoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TomatoPageState();
  }
}

class _TomatoPageState extends State<TomatoPage> {
  List<Knowledge> _list = [];
  var _knowledgeProvider = KnowledgeProvider();

  @override
  void initState() {
    super.initState();
    
  }
  getDataFromDb() async{
    _knowledgeProvider.open(await getDatabasesPath());
    var list = await _knowledgeProvider.getAll();
    setState(() {
      _list = list;
    });
  }
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
                times: 5),
            ..._list
                .map((e) => ListItem(
                      icon: Icon(
                        Icons.article,
                        color: Colors.blue,
                      ),
                      title: e.title,
                      onTap: () {
                        gotoBrowser(context, e.url);
                      },
                    ))
                .toList()
          ],
        ),
      ),
    );
  }
}
