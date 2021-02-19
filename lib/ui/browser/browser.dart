import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _BrowserPageState();
  }
}

class _BrowserPageState extends State<BrowserPage> {
  final Completer<WebViewController> _controller = Completer();
  final TextEditingController _textEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _textEditingController.text = 'https://';
  }
  JavascriptChannel _getVideoUrl(BuildContext context) {
    return JavascriptChannel(
        name: 'FlutterUrl',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          print('-----------------value-------------------');
          print(message);
          print('-----------------value-------------------');

        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: WebView(
            initialUrl: "https://www.baidu.com",
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>[
             _getVideoUrl(context),
            ].toSet(),
            onWebViewCreated: (WebViewController controller) {
              _controller.complete(controller);
            },
            navigationDelegate: (NavigationRequest request) {
              if (!request.url.startsWith('http')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              setState(() {
                isLoading = true;
              });
            },
            onPageFinished: (String url) {
              _controller.future.then((c) {
                c.evaluateJavascript('FlutterUrl.postMessage(document.querySelector(\'video\').src)');
              });
              setState(() {
                isLoading = false;
              });
            },
          ),
        ),
        Container(
          height: 60.0,
          padding: EdgeInsets.only(right: 10.0, left: 10.0),
          child: Row(
            children: [
              isLoading ? Icon(Icons.all_inclusive_sharp): Container(),
              Expanded(
                  child: TextField(
                keyboardType: TextInputType.url,
                controller: _textEditingController,
              )),
              ElevatedButton(
                  onPressed: () {
                    _controller.future.then((c) {
                      c.evaluateJavascript('document.querySelector(\'video\').src').then((value) => print(value));
                    });
                  },
                  child: Text("search")),
              ElevatedButton(
                  onPressed: () {
                    _controller.future.then((c) {
                      c.reload();
                    });
                  },
                  child: Text("reload"))
            ],
          ),
        )
      ],
    ));
  }
}
