import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _BrowserPageState();
  }
}

class _BrowserPageState extends State<BrowserPage> {
  // IjkMediaController controller = IjkMediaController();
  final Completer<WebViewController> _controller = Completer();
  final TextEditingController _textEditingController = TextEditingController();
  bool isLoading = false;
  bool isShowVideoPlayer = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _textEditingController.text = 'https://';
    this.getVideo();
  }

  @override
  void didUpdateWidget(BrowserPage oldWidget) {
    debugPrint("didUpdateWidget");
  }

  @override
  void deactivate() {
    // controller.dispose();
  }

  getVideo() async {
    // var c = await _controller.future;
    debugPrint("getVideo");
    // controller.pauseOtherController();
    // controller.setNetworkDataSource("https://upos-sz-mirrorcos.bilivideo.com/upgcxcode/76/37/335023776/335023776_nb2-1-16.mp4?e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfq9rVEuxTEnE8L5F6VnEsSTx0vkX8fqJeYTj_lta53NCM=&uipk=5&nbs=1&deadline=1620388963&gen=playurlv2&os=cosbv&oi=3664411466&trid=38bd3546b29e4a70ae710e757197c761h&platform=html5&upsig=f09359b1eacf02658d7f01fa1722f546&uparams=e,uipk,nbs,deadline,gen,os,oi,trid,platform&mid=0&logo=80000000",
    //     headers: {
    //       'user-agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1'
    //     },
    //     autoPlay: true);
    // c.evaluateJavascript(
    //     'let video = document.querySelector("video");'
    //     'if (video) {'
    //     'FlutterUrl.postMessage(video.src)'
    //     '}');
  }
  Widget t() {
    return  AndroidView(viewType: "viewType");
  }
  JavascriptChannel _getVideoUrl(BuildContext context) {
    return JavascriptChannel(
        name: 'FlutterUrl',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          print('-----------------value-------------------');
          print('_getVideoUrl' + message.message);
          if (message.message != null) {
            // if (controller.isPlaying) {
            //   return;
            // }
            // controller.setNetworkDataSource(message.message,
            //     headers: {
            //       'user-agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1'
            //     },
            //     autoPlay: true);
          }
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
          child: RefreshIndicator(
            onRefresh: () async{
              var c = await _controller.future;
              c.reload();
              return;
            },
            child: WebView(
              debuggingEnabled: true,
              initialUrl: "https://m.baidu.com/",
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
          ),),
    ));
  }
}
