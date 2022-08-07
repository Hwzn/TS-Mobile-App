import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ts_academy/ui/styles/colors.dart';

// ignore: must_be_immutable
class CachedImage extends StatelessWidget {
  double height;
  double width;
  final double radius;
  final String imageUrl;
  final BoxFit boxFit;
  Widget errorWidget;

  CachedImage({
    Key key,
    this.imageUrl,
    this.height = 300,
    this.width = 300,
    this.radius = 0,
    this.errorWidget,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: FancyShimmerImage(
        imageUrl: imageUrl,
        boxFit: boxFit,
        height: height,
        shimmerBaseColor: AppColors.primaryColor,
        shimmerHighlightColor: AppColors.secondaryElement.withOpacity(0.2),
        shimmerBackColor: AppColors.accentElement,
        width: width,
        errorWidget: errorWidget ??
            Image.asset(
              'assets/images/appicon.png',
              fit: BoxFit.contain,
              height: height / 2,
              width: width / 2,
            ),
      ),
    );
  }
  // return FadeInImage(
  //   placeholder: AssetImage('assets/images/logo.png'),
  //   image: NetworkImage(imageUrl),
  //   imageErrorBuilder:
  //       (BuildContext context, Object exception, StackTrace stackTrace) {
  //     return Text('Your error widget...');
  //   },
  //   height: height,
  //   width: width,
  //   fit: boxFit,
  // );
  // }
}
