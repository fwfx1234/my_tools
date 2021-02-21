import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
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
  VideoPlayerController _videoPlayerController;
  ChewieController chewieController;
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
    c.evaluateJavascript(
        'let video = document.querySelector("video");'
            'if (video) {'
            'FlutterUrl.postMessage(video.src)'
            '}'
    );
  }
  JavascriptChannel _getVideoUrl(BuildContext context){

    return JavascriptChannel(
        name: 'FlutterUrl',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          print('-----------------value-------------------');
          print('value' + message.message);
          if (message.message != null) {
            init(message.message);
          }
          print('-----------------value-------------------');
        });
  }

  @override
  void dispose() {
    if (_videoPlayerController !=null) {
      _videoPlayerController.dispose();
    }
    if (chewieController !=null) {
      chewieController.dispose();
    }
  }

  init(String url) async {
    print('init');
    isShowVideoPlayer = false;

    if (_videoPlayerController !=null) {
      _videoPlayerController.dispose();
    }
    if (chewieController !=null) {
      chewieController.dispose();
    }
    _videoPlayerController = VideoPlayerController.network(url);
    await _videoPlayerController.initialize();
    print('init success');
    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    setState(() {
      isShowVideoPlayer = true;
    });
  }
  Widget _videoPlayer() {
    return Positioned(
        top: 0.0,
        left: 0.0,
        child: Builder(builder: (context){
              return Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                     maxHeight: 300.0
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      isShowVideoPlayer ?
                      Chewie(
                        controller: chewieController,
                      ) : Text('Loading'),
                      TextButton(onPressed: ()async{

                      }, child: Text("play", style: TextStyle(color: Colors.blue),))
                    ],
                  )
              );

            }) ) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            onWillPop: () async {
              var c = await _controller.future;
              if (await c.canGoBack()) {
                await c.goBack();
                return false;
              }
              return true;
            },
            child: Overlay(initialEntries: [
              OverlayEntry(builder: (context) =>
                  Column(
                    children: [
                      isShowVideoPlayer ? _videoPlayer() : Container(),
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
                            _controller.future.then((c) {

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
                            isLoading
                                ? Icon(Icons.all_inclusive_sharp)
                                : Container(),
                            Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.url,
                                  controller: _textEditingController,
                                )),
                            ElevatedButton(
                                onPressed: ()async {
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
                            ElevatedButton(
                                onPressed: () {
                                 getVideo();
                                },
                                child: Text("v"))
                          ],
                        ),
                      )
                    ],
                  )),
            ],)));
  }
}
