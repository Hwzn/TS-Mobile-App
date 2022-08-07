import 'package:flutter/material.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

class CustomContentContainer extends StatelessWidget {
  final double width;
  final double height;

  const CustomContentContainer(this.width, this.height);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ContentPainter(),
      child: Container(
        width: width,
        height: height,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 33, right: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text("Add Content",
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 1.5,
                          color: Colors.white)),
                ),
                Expanded(
                  flex: 3,
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

class ContentPainter extends CustomPainter {
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
    path.lineTo(size.width * .2, size.height / 2);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
