import 'package:flutter/services.dart';
import 'package:my_tools/beans/tomato/knowledge_bean.dart';

class ApiKnowledge {
  static Future<List<KnowledgeBean>> getKnowledgeList() async{
    var file = await rootBundle.loadString('lib/assets/data/main.csv');
    var list = file.split('\n');
    return list.map((e){
      var it = e.split(',');
      return KnowledgeBean(it[3], it[2] , it[1], it[0]);
    }).toList();
  }
}