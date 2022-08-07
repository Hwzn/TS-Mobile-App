import 'package:flutter/material.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

class CustomSectionContainer extends StatelessWidget {
  final double width;
  final double height;

  const CustomSectionContainer(this.width, this.height);
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return CustomPaint(
      painter: Chevron(),
      child: Container(
        width: width,
        height: height,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(locale.get('Add Section'),
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 1.5,
                          color: Colors.white)),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: SizeConfig.imageSizeMultiplier * 5,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Chevron extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = new LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.blue, Colors.lightBlueAccent],
      tileMode: TileMode.clamp,
    );

    final Rect colorBounds = Rect.fromLTRB(0, 0, size.width, size.height);
    final Paint paint = new Paint()
      ..shader = gradient.createShader(colorBounds);

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * .8, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width * .8, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
