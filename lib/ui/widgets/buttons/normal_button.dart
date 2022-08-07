import 'package:flutter/material.dart';

import '../../../core/services/localization/localization.dart';
import '../../styles/colors.dart';

class NormalButton extends StatelessWidget {
  final bool localize;
  final bool busy;
  final bool bold;
  final double width;
  final double height;
  final double raduis;
  final double elevation;
  final String text;
  final Widget child;
  final Color color;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Function onPressed;
  final Color textColor;
  const NormalButton(
      {Key key,
      this.busy = false,
      this.localize = true,
      this.child,
      this.onPressed,
      this.text = 'ok',
      this.width,
      this.height,
      this.elevation = 0,
      this.raduis = 2,
      this.margin = const EdgeInsets.symmetric(vertical: 5),
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      this.textColor = Colors.white,
      this.color = AppColors.secondaryElement,
      this.bold = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: margin,
      child: MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(raduis)),
        elevation: elevation,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: elevation,
        minWidth: width ?? double.infinity,
        color: color,
        height: height ?? 60,
        onPressed: () => onPressed == null || busy ? {} : onPressed(),
        child: Padding(
          padding: padding,
          child: child ??
              Text(
                localize ? locale.get(text) ?? text : text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
        ),
      ),
    );
  }
}
