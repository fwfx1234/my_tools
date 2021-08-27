import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_tools/db/knowledge.dart';
import 'package:my_tools/router/routers.dart';
import 'package:my_tools/ui/tomato/list_item.dart';
import 'package:my_tools/utils/common.dart';

class TomatoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TomatoPageState();
  }
}

class _TomatoPageState extends State<TomatoPage>
    with RouteAware, TickerProviderStateMixin {
  List<List<Knowledge>> _list = [];
  List<String> _tabs = [];
  int? _readArticleId;
  DateTime? _readTime;
  bool _bottomSheetIsOpened = false;
  var _knowledgeProvider = KnowledgeProvider();

  late TabController _tabController;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    _getAllModule();
  }

  _getAllModule() async {
    var modules = await _knowledgeProvider.getAllModule();
    setState(() {
      _tabs = ["All", ...modules];
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.addListener(() {
        _pageController.animateToPage(_tabController.index,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      });
      _list = List.filled(_tabs.length, []);
    });
  }

  Future<List<Knowledge>> _getListByModule(int index, [refresh = false]) async {
    if (_list[index].isNotEmpty && !refresh) {
      return _list[index];
    }
    var module = _tabs[index];
    if (module == 'All') {
      var res = await _knowledgeProvider.getAll();
      _list[index] = res;
      return res;
    } else {
      var res = await _knowledgeProvider.getListByModule(module);
      _list[index] = res;
      return res;
    }
  }

  _updateListByIndex(int index) async {
    await Future.wait(
        [_getListByModule(index, true), _getListByModule(0, true)]);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyRouter.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // 超过一分钟自动已读
    if (_readTime != null &&
        _readArticleId != null &&
        DateTime.now().second - _readTime!.second > 30 &&
        !_bottomSheetIsOpened) {
      _knowledgeProvider.setReadState(_readArticleId!, true);
      _updateListByIndex(_tabController.index);
    }
    super.didPopNext();
  }

  @override
  void dispose() {
    _knowledgeProvider.close();
    MyRouter.routeObserver.unsubscribe(this);
    super.dispose();
  }

  Widget _buildKnowledgeList(List<Knowledge> list) {
    return ListView(
        children: list
            .map((e) => ListItem(
                item: e,
                onTap: () {
                  _readArticleId = e.id;
                  _readTime = DateTime.now();
                  gotoBrowser(context, e.url);
                },
                onLongPress: (id) {
                  _bottomSheetIsOpened = true;
                  showModalBottomSheet(
                      context: context,
                      builder: (_) => Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await _knowledgeProvider.setReadState(
                                        id, true);
                                    _updateListByIndex(_tabController.index);
                                    Navigator.pop(context);
                                    _bottomSheetIsOpened = false;
                                  },
                                  child: Container(
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black12))),
                                    child: Center(child: Text("设置为已读")),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await _knowledgeProvider.setReadState(
                                        id, false);
                                    _updateListByIndex(_tabController.index);
                                    _bottomSheetIsOpened = false;
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 60.0,
                                    child: Center(child: Text("设置为未读")),
                                  ),
                                )
                              ],
                            ),
                          ));
                }))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        TabBar(
            isScrollable: true,
            labelColor: Colors.black87,
            controller: _tabController,
            tabs: _tabs
                .map((e) => Tab(
                      child: Text(e),
                    ))
                .toList()),
        Expanded(
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _tabController.animateTo(index);
                },
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  print('index: $index');
                  return StreamBuilder<List<Knowledge>>(
                      stream: _getListByModule(index).asStream(),
                      builder: (context, data) {
                        if (data.hasError) {
                          return Container(
                              child: Text('error: ${data.stackTrace}'));
                        }
                        if (data.data == null) {
                          return Center(child: Text('加载中'));
                        }
                        return _buildKnowledgeList(data.data!);
                      });
                }))
      ],
    )));
  }
}
