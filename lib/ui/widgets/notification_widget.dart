import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:ts_academy/ui/styles/colors.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String body;
  final Map<dynamic, dynamic> data;

  NotificationWidget({Key key, this.title, this.body, this.data})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Dismissible(
      key: key,
      onDismissed: (direction) {
        OverlaySupportEntry.of(context).dismiss(animate: false);
      },
      child: Card(
        color: Colors.transparent,
        elevation: 10,
        shadowColor: AppColors.primaryColor,
        margin: EdgeInsets.all(7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: MediaQuery.of(context).size.height * .1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.secondry),
          child: ListTile(
            // leading: SizedBox(
            //     width: 35,
            //     height: 35,
            //     child: Image.asset("assets/images/logo.png", color: textColor)),
            onTap: () {
              OverlaySupportEntry.of(context).dismiss();
            },
            title: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width * .8,
              child: Text(title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            subtitle: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Text(body ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  )),
            ),
          ),
        ),
      ),
    ));
  }
}
