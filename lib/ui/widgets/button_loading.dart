import 'package:flutter/material.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

class ButtonLoading extends StatelessWidget {
  final double loadingImageHeight;

  const ButtonLoading({this.loadingImageHeight});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image.asset(
          'assets/images/loading.gif',
          height: loadingImageHeight ?? SizeConfig.imageSizeMultiplier * 25,
        ),
      ),
    );
  }
}
