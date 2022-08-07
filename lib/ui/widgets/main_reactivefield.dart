import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MainReactiveField extends StatelessWidget {
  final String controllerName;
  final bool obsecureText;
  final TextInputType inputType;
  final String label;
  final int maxLines;
  final contextPadding;
  final Widget suffixIcon;
  final bool isVisable;
  final bool isReadOnly;
  final Function onTap;

  final validationMessages;

  MainReactiveField(
      {@required this.controllerName,
      this.obsecureText = false,
      this.inputType = TextInputType.text,
      this.suffixIcon,
      this.isVisable = false,
      this.maxLines = 1,
      this.contextPadding,
      this.label,
      this.onTap,
      this.isReadOnly = false,
      this.validationMessages});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: ReactiveTextField(
        readOnly: isReadOnly,
        keyboardType: inputType,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          // color: Colors.grey.shade100,
        ),
        obscureText: obsecureText,
        maxLines: maxLines <= 0 ? 1 : maxLines,
        validationMessages: validationMessages,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          contentPadding: contextPadding ?? const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade100),
          ),
          hintText: label ?? controllerName,
          hintStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400),
        ),
        formControlName: controllerName,
        autofocus: false,
        onTap: onTap ?? () {},
      ),
    );
  }
}
