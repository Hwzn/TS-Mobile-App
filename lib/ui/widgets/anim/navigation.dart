import 'package:flutter/material.dart';

enum ANIM_TYPE { slide_from_bottom, slide_from_right, scale }

class AnimatedRoute extends PageRouteBuilder {
  final Widget page;
  final ANIM_TYPE type;
  AnimatedRoute({@required this.page, @required this.type})
      : super(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              animation =
                  CurvedAnimation(curve: Curves.linear, parent: animation);

              Widget ret;

              if (type == ANIM_TYPE.scale) {
                ret = ScaleTransition(
                  scale: animation,
                  child: child,
                );
              } else if (type == ANIM_TYPE.slide_from_bottom) {
                ret = SlideTransition(
                  position: Tween(begin: Offset.zero, end: Offset(0, 5))
                      .animate(animation),
                  child: child,
                );
              } else if (type == ANIM_TYPE.slide_from_right) {
                ret = SlideTransition(
                  position:
                      Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                          .animate(animation),
                  child: child,
                );
              }

              return ret;
              // return SlideTransition(
              //   position: Tween<Offset>(
              //     begin: const Offset(0, 1),
              //     end: Offset.zero,
              //   ).animate(animation),
              //   child: child,
              // );
              // return FadeTransition(opacity: animation, child: child);
              // return FadeTransition(opacity: animation, child: child);
            });
}
