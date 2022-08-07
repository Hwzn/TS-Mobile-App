// import 'package:flutter/material.dart';

// typedef HeroBuilder = Widget Function(BuildContext context);

// class HeroWidget extends StatelessWidget {
//   final HeroBuilder heroBuilder;
//   final Object heroTag;
//   final double width;
//   final VoidCallback onTap;

//   const HeroWidget(
//       {Key key,
//       @required this.heroBuilder,
//       @required this.heroTag,
//       this.width = 100,
//       this.onTap})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       child: Hero(
//         tag: heroTag,
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: onTap,
//             child: heroBuilder(context),
//           ),
//         ),
//       ),
//     );
//   }
// }
