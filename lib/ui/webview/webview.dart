import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final bool isShowNavBar;
  final String url;
  final bool isShowAppBar;

  WebViewPage(
      {required this.url,
      this.isShowNavBar = false,
      this.isShowAppBar = false});

  @override
  State<StatefulWidget> createState() {
    return _WebViewState();
  }
}

class _WebViewState extends State<WebViewPage> {
  final Completer<WebViewController> _controller = Completer();
  String _title = '';
  double _loadingValue = 0.0;
  bool _isShowLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isShowAppBar
          ? AppBar(
              title: Text(_title),
            )
          : null,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            var c = await _controller.future;
            if (await c.canGoBack()) {
              await c.goBack();
              return false;
            }
            return true;
          },
          child: Stack(
            children: [

              Container(
                color: Colors.white,
                child: WebView(
                  onWebViewCreated: (c) {
                    _controller.complete(c);
                  },
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  navigationDelegate: (NavigationRequest request) {
                    if (!request.url.startsWith('http')) {
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                  onProgress: (value) {
                    setState(() {
                      _loadingValue = value / 100;
                    });
                  },
                  onPageFinished: (url) async {
                    var c = await _controller.future;
                    var title = await c.getTitle() ?? '';
                    setState(() async {
                      _title = title;
                      _isShowLoading = false;
                    });
                  },
                ),
              ),
              Positioned(
                  child: _isShowLoading ? LinearProgressIndicator(
                    minHeight: 2.0,
                    color: Colors.blue,
                    value: this._loadingValue,
                  ): Container()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.isShowNavBar
          ? BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.arrow_back_outlined), label: "返回"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined), label: '首页'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置')
              ],
            )
          : null,
    );
  }
}
