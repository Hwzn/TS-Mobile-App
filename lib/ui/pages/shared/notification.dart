import 'package:flutter/material.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: SizeConfig.heightMultiplier * 8,
                child: Center(
                  child: Text(
                    'Notification',
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.5,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
