import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeItem extends StatelessWidget {
  final Image image;
  final String title;
  final String content;

  HomeItem({@required this.image, @required this.title, this.content = '默认描述'});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try{
          var platform =  new MethodChannel("com.example.my_tools/activity");
          String result = await platform.invokeMethod("startActivity", ["WebViewActivity"]);
          print(result);
        }catch(e) {
          print(e);
        }
      },
      child: Card(
          shadowColor: Colors.black12,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  child: image,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                ),
                Text(
                  content,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38),
                )
              ],
            ),
          )),
    );
  }
}
