import 'package:flutter/material.dart';

class ScreenUtils {
  static bool isInit = false;
  late BuildContext _context;
  late double dpi;
  late double screenWidth;
  late double screenHeight;
  double? designWidth;
  double? designHeight;
  static ScreenUtils? _instance;

  ScreenUtils.init(BuildContext _context,
      [double? designWidth, double? designHeight])
      : this(_context, designWidth, designHeight);

   ScreenUtils(BuildContext context, [double? designWidth, double? designHeight])
      : assert(designHeight == null && designHeight == null, '设计稿宽度和高度最少有一个') {
    this._context = context;
    var m = MediaQuery.of(context);
    this.dpi = m.devicePixelRatio;
    this.screenWidth = m.size.width;
    this.screenHeight = m.size.height;
    this.designHeight = designHeight;
    this.designWidth = designWidth;
    isInit = true;
  }

  ScreenUtils._internal() : assert(isInit, "must init before getInstance");

  factory ScreenUtils.getInstance() => _getInstance();

  static _getInstance() {
    if (_instance == null) {
      _instance = ScreenUtils._internal();
    }
    return _instance;
  }

  double vh(double px) {
    assert(designHeight == null, '未设置设计稿高度');
    return px * (screenHeight * dpi) / designHeight!;
  }
  double vw(double px) {
    assert(designWidth == null, '未设置设计稿宽度');
    return px * (screenWidth * dpi) / designWidth!;
  }
}
