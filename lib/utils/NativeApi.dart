import 'package:flutter/services.dart';

class NativeApi {
  static var _activityChannel = 'com.example.my_tools/activity';

  static Future<String> startBrowser({String url = 'https://www.baidu.com'}) async{
    var platform =  new MethodChannel(_activityChannel);
    if (!url.startsWith('http')) {
      url = 'https://' + url;
    }
    return await platform.invokeMethod("startActivity", ["WebViewActivity", url]);
  }
}