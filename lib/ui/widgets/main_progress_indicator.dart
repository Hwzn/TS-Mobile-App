import 'package:flutter/material.dart';

import '../styles/colors.dart';

class MainProgressIndicator extends StatelessWidget {
  final Color color;
  final double strokeWidth;

  MainProgressIndicator({
    this.color = AppColors.primaryColor,
    this.strokeWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(

        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: strokeWidth,
      ),
    );
  }
}
