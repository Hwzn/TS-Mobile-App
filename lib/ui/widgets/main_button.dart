import 'package:flutter/material.dart';

import '../styles/colors.dart';

class MainButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final padding;
  final textStyle;
  final color;
  final double height;
  MainButton({this.onTap, this.text, this.padding, this.textStyle, this.color  ,this.height = 40});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        decoration: BoxDecoration(
          color: color ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            text ?? '',
            style: textStyle ??
                TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}