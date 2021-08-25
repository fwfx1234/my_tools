import 'dart:async';
import 'dart:io';

import 'package:my_tools/api/api_knowledge.dart';
import 'package:sqflite/sqflite.dart';

const String tb = 'tb_knowledge';

class Knowledge {
  late final String url;
  late final String title;
  late final String type;
  late final String module;
  int? id;
  bool isRead = false;
  DateTime? updateTime;

  Knowledge(this.url, this.title, this.type, this.module);

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'url': url,
      'title': title,
      'type': type,
      'module': module,
      'is_read': isRead ? 1 : 0,
      'update_time': updateTime?.microsecondsSinceEpoch
    };
    return map;
  }

  Knowledge.fromMap(Map<String, Object?> map) {
    if (map.containsKey('id') && map['id'] != 'Null') {
      this.id = map['id'] as int;
    }
    this.url = map['url'] as String? ?? '';
    this.title = map['title'] as String? ?? '';
    this.type = map['type'] as String? ?? '';
    this.module = map['module'] as String? ?? '';
    this.isRead = map['is_read'] == 1;
    if (map.containsKey('update_time') && map['update_time'] != null) {
      this.updateTime =
          DateTime.fromMicrosecondsSinceEpoch(map['update_time'] as int);
    }
  }
}

class KnowledgeProvider {
  KnowledgeProvider() {
    getDatabasesPath().then((value) => open(value));
  }
  Completer<Database> _handle = Completer();
  Future open(String path) async {
    var dbPath = '$path/knowledge.db';
    var db = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
            create table $tb (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              url text not null UNIQUE,
              title char(50) not null,
              type char(10) not null,
              module char(10) not null,
              is_read int  default 0,
              update_time int 
            )
            ''');
      await _initDataFromLocal(db);
    });
    _handle.complete(db);
  }

  Future _initDataFromLocal(Database db) async {
    var initData = await ApiKnowledge.getKnowledgeList();
    await Future.wait(initData.map((element) => db.insert(
        tb,
        Knowledge(element.url, element.title, element.type, element.module)
            .toMap())));
  }

  Future<Knowledge> insert(Knowledge item) async {
    var db = await _handle.future;
    await db.insert(tb, item.toMap());
    return item;
  }

  Future<int> setReadState(int id, bool isRead) async {
    var db = await _handle.future;

    return await db.update(
        tb,
        {
          'is_read': isRead ? 1 : 0,
          'update_time': DateTime.now().microsecondsSinceEpoch
        },
        where: 'id = ? ',
        whereArgs: [id]);
  }

  Future<List<String>> getAllType() async {
    var db = await _handle.future;

    var _list = await db.rawQuery("select type from $tb group by type");
    return _list.map((e) => e['type']! as String).toList();
  }

  Future<List<String>> getAllModule() async {
    var db = await _handle.future;

    var res = await db.rawQuery("select module from $tb group by module");
    return res.map((e) => e['module']! as String).toList();
  }

  Future<List<Knowledge>> getAll() async {
    var db = await _handle.future;

    var _list = await db.query(tb);
    return _list
        .map((e) => Knowledge.fromMap(e))
        .skipWhile((e) => e.url.startsWith('http'))
        .toList();
  }
  Future<List<Knowledge>> getListByModule(String module) async {
    var db = await _handle.future;

    var _list = await db.query(tb, where: "module = ?", whereArgs: [module]);
    return _list
        .map((e) => Knowledge.fromMap(e))
        .skipWhile((e) => e.url.startsWith('http'))
        .toList();
  }

  Future close() async => await _handle.future
    ..close();
}
