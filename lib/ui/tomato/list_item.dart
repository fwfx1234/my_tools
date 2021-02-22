import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';

class ListItem extends StatelessWidget {
  final String title;
  final Icon icon;
  final String time;
  final int times;

  ListItem({@required this.icon, @required this.title, this.time, this.times})
      : assert(icon != null, "icon != null"),
        assert(title != null, "title !=null");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.black.withOpacity(0.1),
      highlightColor: Colors.white,
      onTap: () {},
      child: Container(
        height: 55.0.w,
        padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                Padding(
                  padding: EdgeInsets.only(left: 5.0.w),
                  child: Text(title),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                this.time != null
                    ? Text(
                        "${time}h",
                        style: TextStyle(color: Colors.black26),
                      )
                    : Container(),
                this.times != null
                    ? Padding(
                        padding: EdgeInsets.only(left: 10.0.w),
                        child: Text(times.toString(),
                            style: TextStyle(color: Colors.black26)),
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}
