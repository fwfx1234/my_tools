import 'dart:async';
import 'dart:io';

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
  String url = 'http://www.baidu.com';
  int _loadingValue = 0;
  bool _isShowLoading = false;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: true
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
          child: RefreshIndicator(
            onRefresh: () async{
              var c = await _controller.future;
              c.reload();
              return;
            },
            child: WebView(
              debuggingEnabled: true,
              onWebViewCreated: (c) async{
                _controller.complete(c);
                debugPrint("finish ${widget.url}");
              },
              initialUrl: widget.url.trim(),
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                if (!request.url.startsWith('http')) {
                  debugPrint("prevent ${widget.url}");
                  return NavigationDecision.prevent;
                }
                debugPrint("allow ${widget.url}");
                return NavigationDecision.navigate;
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
        ),
      ),

    );
  }
}
