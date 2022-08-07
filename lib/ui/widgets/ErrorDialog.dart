
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class ErrorDialog extends StatelessWidget {
  @required
  final Color color;
  final Color btnColor;
  final String error;
  final Function onPressedBtn;
  const ErrorDialog({
    Key key,
    this.onPressedBtn,
    this.btnColor,
    this.error,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
        text: 'Error Dialog',
        color: color,
        pressEvent: () {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: false,
              title: 'Error',
              desc: error,
              btnOkOnPress: () {
                Navigator.pop(context);
              },
              btnOkIcon: Icons.cancel,
              btnOkColor: btnColor)
            ..show();
        });
  }

  void notification(String message, Color colors, {postion}) {
    showSimpleNotification(Text(message),
        slideDismiss: true,
        position: postion ?? NotificationPosition.top,
        duration: Duration(seconds: 2),
        background: colors);
  }

  void notificationDialog(String message, Color colors) {
    showSimpleNotification(
        Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        slideDismiss: false,
        position: NotificationPosition.bottom,
        contentPadding: EdgeInsets.all(10),
        duration: Duration(seconds: 4),
        background: colors);
  }
}
