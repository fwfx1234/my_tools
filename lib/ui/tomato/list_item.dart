import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_tools/db/knowledge.dart';

class ListItem extends StatelessWidget {
  final Knowledge item;
  final void Function() ? onTap;
  final void Function(int id)? onLongPress;
  ListItem({required this.item, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.black.withOpacity(0.1),
      highlightColor: Colors.white,
      onTap: () {
        if (this.onTap != null) {
          this.onTap!();
        }
      },
      onLongPress: () {
        if (this.onLongPress != null) {
          this.onLongPress!(item.id!);
        }
      },
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
                item.isRead ? Icon(Icons.article_rounded, color: Colors.green,)  : Icon(Icons.article_outlined, color: Colors.grey,),
                Padding(
                  padding: EdgeInsets.only(left: 5.0.w),
                  child: Text('${item.id}: ${item.title}'),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                item.updateTime != null && item.isRead ? Text(DateFormat('yyyy-MM-dd').format(item.updateTime!)) : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}
