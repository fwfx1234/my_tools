import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';

class HomeItem extends StatelessWidget {
  final Image image;
  final String title;
  final String content;
  final void Function() onTap;
  HomeItem({@required this.image, @required this.title, this.content = '默认描述', this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this?.onTap();
      },
      child: Card(
          shadowColor: Colors.black12,
          child: Container(
            padding: EdgeInsets.all(10.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.0.w,
                  height: 36.0.w,
                  child: image,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 14.0.w, color: Colors.black87),
                ),
                Text(
                  content,
                  style: TextStyle(
                      fontSize: 12.0.w,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38),
                )
              ],
            ),
          )),
    );
  }
}
