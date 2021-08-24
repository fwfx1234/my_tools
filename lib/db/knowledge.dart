import 'package:my_tools/api/api_knowledge.dart';
import 'package:sqflite/sqflite.dart';
const String tb = 'tb_knowledge';
class Knowledge {
  int? id;
  late final String url;
  late final String title;
  late final String type;
  late final String module;
  Knowledge(this.url, this.title, this.type, this.module);

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'id': id,
      'url': url,
      'title': title,
      'type': type,
      'module': module
    };
    return map;
  }

  Knowledge.fromMap(Map<String, Object?> map) {
    this.id = map['id'] as int? ?? 0;
    this.url = map['url'] as String? ?? '';
    this.title = map['title'] as String? ?? '';
    this.type = map['type'] as String? ?? '';
    this.module = map['module'] as String? ?? '';
  }
}

class KnowledgeProvider {
  Database? db;
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
        create table $tb ( 
        id integer autoincrement, 
        url text not null primary key,
        title text not null,
        type text not null,
        module text not null
        )
        ''');
        });
    ApiKnowledge.getKnowledgeList().then((value) => {
      value.forEach((element) {
        insert(Knowledge(element.url, element.title, element.type, element.module));
      })
    });
  }
  
  Future<Knowledge> insert(Knowledge item) async {
    if (db == null) {
      return Future.error("db 未初始化: $tb");
    }
    await db?.insert(tb, item.toMap());
    return item;
  }
  Future<List<Knowledge>> getAll() async {
    if (db == null) {
      return Future.error("db 未初始化: $tb");
    }
    var _list = await db!.query(tb);
    return _list.map((e) => Knowledge.fromMap(e)).toList();
  }
}