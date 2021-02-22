import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/size_extension.dart';

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
  bool isShowVideoPlayer = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _textEditingController.text = 'https://';
  }

  getVideo() async {
    var c = await _controller.future;
    c.evaluateJavascript('let video = document.querySelector("video");'
        'if (video) {'
        'FlutterUrl.postMessage(video.src)'
        '}');
  }

  JavascriptChannel _getVideoUrl(BuildContext context) {
    return JavascriptChannel(
        name: 'FlutterUrl',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          print('-----------------value-------------------');
          print('value' + message.message);
          if (message.message != null) {}
          print('-----------------value-------------------');
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                  builder: (context) => Column(
                        children: [
                          Expanded(
                            child: WebView(
                              debuggingEnabled: true,
                              initialUrl: "https://m.bilibili.com/",
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
                                _controller.future.then((c) {});
                                setState(() {
                                  isLoading = false;
                                });
                              },
                            ),
                          ),
                          Container(
                            height: 60.0.w,
                            padding:
                                EdgeInsets.only(right: 10.0.w, left: 10.0.w),
                            child: Row(
                              children: [
                                isLoading
                                    ? Icon(Icons.all_inclusive_sharp)
                                    : Container(),
                                Expanded(
                                    child: TextField(
                                  keyboardType: TextInputType.url,
                                  controller: _textEditingController,
                                )),
                                ElevatedButton(
                                    onPressed: () async {
                                      var c = await _controller.future;
                                      c.loadUrl(_textEditingController.text);
                                    },
                                    child: Text("search")),
                                ElevatedButton(
                                    onPressed: () {
                                      _controller.future.then((c) {
                                        c.reload();
                                      });
                                    },
                                    child: Text("reload")),
                              ],
                            ),
                          )
                        ],
                      )),
            ],
          )),
    ));
  }
}
